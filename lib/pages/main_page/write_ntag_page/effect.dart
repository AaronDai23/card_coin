import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/ntag_ndef_writer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

void _log(String msg) => debugPrint('NTAGWRITE: $msg');

const MethodChannel _nfcChannel = MethodChannel('com.cardcoin.card_coin/nfc');

/// Toggle the native Activity's NFC foreground dispatch. Must be disabled
/// while an nfc_manager reader session is active, otherwise both fire on the
/// same tap and disrupt the tag connection mid-write.
Future<void> _setNativeForegroundDispatch(bool enabled) async {
  if (!Platform.isAndroid) return;
  try {
    await _nfcChannel.invokeMethod(
      'setForegroundDispatchEnabled',
      {'enabled': enabled},
    );
    _log('native foreground dispatch enabled=$enabled');
  } catch (e) {
    _log('setForegroundDispatchEnabled($enabled) failed: $e');
  }
}

Effect<WriteNtagState>? buildEffect() {
  return combineEffects(<Object, Effect<WriteNtagState>>{
    Lifecycle.initState: _onLoadConfig,
    WriteNtagAction.loadConfig: _onLoadConfig,
    WriteNtagAction.startWrite: _onStartWrite,
    WriteNtagAction.startDecode: _onStartDecode,
    WriteNtagAction.cancelScan: _onCancelScan,
    Lifecycle.dispose: _onDispose,
  });
}

Future<void> _onDispose(Action action, Context<WriteNtagState> ctx) async {
  await _finishSession();
}

Future<void> _onCancelScan(Action action, Context<WriteNtagState> ctx) async {
  await _finishSession();
  ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('Cancelled'));
}

/// Full cleanup AFTER a session ends: stop the reader session and reset the
/// app's native NFC reader mode. Never call this immediately before
/// `startSession`.
Future<void> _finishSession() async {
  try {
    await NfcManager.instance.stopSession();
  } catch (_) {}
  try {
    await BlockchainPlatform.instance.resetNfcReaderMode();
  } catch (_) {}
  // Restore the Activity's normal NFC foreground dispatch.
  await _setNativeForegroundDispatch(true);
}

Future<void> _onLoadConfig(Action action, Context<WriteNtagState> ctx) async {
  try {
    final params = <String, dynamic>{};
    final cardUuid = await LocalStorage.getCardUuid();
    if (cardUuid != null && cardUuid.isNotEmpty) {
      params['uid'] = cardUuid;
    }

    final result = await HttpManager.getInstance()
        .post(NetworkAddress.smartCardConfig, null, data: params);

    if (!result.isSuccess) {
      ctx.dispatch(WriteNtagActionCreator.onLoadFailed(
        result.message.isNotEmpty ? result.message : 'Failed to load config',
      ));
      return;
    }

    final data = result.data;
    final domainUrl =
        (data is Map ? data['ndefDomain'] : null)?.toString() ?? '';
    final ndefAAR = (data is Map ? data['ndefAAR'] : null)?.toString() ?? '';

    if (domainUrl.trim().isEmpty) {
      ctx.dispatch(WriteNtagActionCreator.onLoadFailed('ndefDomain is empty'));
      return;
    }
    if (ndefAAR.trim().isEmpty) {
      ctx.dispatch(WriteNtagActionCreator.onLoadFailed('ndefAAR is empty'));
      return;
    }

    ctx.dispatch(WriteNtagActionCreator.onLoadSuccess(
      domainUrl: domainUrl,
      ndefAAR: ndefAAR,
    ));
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
      'Config ready. Scan & Write: detect 213/215 → write URL+AAR → '
      'optional password protect.\nDecode: read URL / uid / AAR back.',
    ));
  } catch (e) {
    ctx.dispatch(WriteNtagActionCreator.onLoadFailed('$e'));
  }
}

Future<void> _runNfcSession({
  required Context<WriteNtagState> ctx,
  required String alertMessage,
  required Future<void> Function(NfcTag tag) onTag,
}) async {
  _log('runNfcSession: begin ($alertMessage)');
  final available = await NfcManager.instance.isAvailable();
  _log('runNfcSession: isAvailable=$available');
  if (!available) {
    showToast('NFC is not available');
    return;
  }

  // NOTE: Do NOT show a modal bottom sheet / dialog while the reader session
  // is active. On EMUI/HarmonyOS, the resulting window-focus change triggers
  // Activity onPause→onResume, and onResume re-enables foreground dispatch,
  // which clobbers the NFC reader mode we just enabled ("reader mode is not
  // active"). Instead we drive an in-page scanning overlay via isScanning,
  // exactly like the working check_card_page.
  ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(true));

  var handled = false;
  final timeout = Timer(const Duration(seconds: 45), () async {
    if (handled) return;
    handled = true;
    await _finishSession();
    ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('Timeout: no tag'));
    showToast('NFC timeout');
  });

  // Disable the native foreground dispatch BEFORE enabling reader mode, so the
  // two NFC paths don't both fire on the same tap (which churns Activity focus
  // and breaks the tag connection mid-write). Restored in _finishSession.
  await _setNativeForegroundDispatch(false);

  // Mirror the proven check_card_page sequence: stop any stale session and
  // start the new one back-to-back with NO awaits in between, so that
  // nfc_manager's enableReaderMode reliably takes over. Do NOT call
  // resetNfcReaderMode here — that would cancel the reader mode we enable.
  NfcManager.instance.stopSession();
  _log('runNfcSession: calling startSession (enableReaderMode)');
  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
    },
    alertMessage: alertMessage,
    onDiscovered: (NfcTag tag) async {
      _log('onDiscovered fired. keys=${tag.data.keys.toList()}');
      if (handled) return;
      handled = true;
      timeout.cancel();
      try {
        await onTag(tag);
        await _finishSession();
        ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
      } catch (e) {
        _log('onDiscovered/onTag error: $e');
        await _finishSession();
        ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
        final msg = '$e';
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
        showToast(msg);
      }
    },
    onError: (NfcError error) async {
      _log('onError: type=${error.type} msg=${error.message}');
      if (handled) return;
      if (error.message.contains('Session invalidated by user')) {
        return;
      }
      handled = true;
      timeout.cancel();
      await _finishSession();
      ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
      final msg = 'NFC error: ${error.message}';
      ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
      showToast(msg);
    },
  );
}

Future<void> _onStartWrite(Action action, Context<WriteNtagState> ctx) async {
  _log('startWrite pressed');
  final domainUrl = ctx.state.domainUrl.trim();
  final packages = NtagNdefWriter.parseAarPackages(ctx.state.ndefAAR);

  if (domainUrl.isEmpty) {
    _log('abort: domainUrl empty');
    showToast('Config not loaded');
    return;
  }
  if (packages.isEmpty) {
    _log('abort: packages empty');
    showToast('ndefAAR is empty from server');
    return;
  }

  if (ctx.state.passwordProtect) {
    final confirmed = await showDialog<bool>(
      context: ctx.context,
      builder: (context) => AlertDialog(
        title: const Text('Password write-protect?'),
        content: Text(
          'After writing URL + browser AAR, the tag will require password '
          'to write again (read/open URL stays free).\n\n'
          'Default password (hex): ${NtagNdefWriter.defaultPasswordHex}\n'
          'If the tag already has a password, you will be asked to unlock '
          'it during the scan.\n'
          'NTAG213/215 are detected automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Scan & Write'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      _log('confirm dialog cancelled');
      return;
    }
    _log('confirm dialog accepted');
  }

  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
    'Hold NTAG… detect 213/215 → if password-protected unlock → write URL+AAR'
    '${ctx.state.passwordProtect ? ' → password protect' : ''}',
  ));

  // Pass 1: probe tag. Write immediately if not password-protected.
  var needsUnlock = false;
  String? pendingUid;
  String? pendingUrl;
  NtagModel pendingModel = NtagModel.unknown;

  await _runNfcSession(
    ctx: ctx,
    alertMessage: 'Hold NTAG213/215 to write',
    onTag: (tag) async {
      _log('write onTag: detecting model…');
      final model = await NtagNdefWriter.detectModel(tag);
      _log('write onTag: model=${NtagNdefWriter.modelLabel(model)}');
      final uidHex = NtagNdefWriter.readTagUidHex(tag);
      _log('write onTag: uid=$uidHex');
      if (uidHex == null || uidHex.isEmpty) {
        throw StateError('Failed to read tag UID');
      }

      final fullUrl = NtagNdefWriter.buildFullNdefUrl(
        domainUrl: domainUrl,
        uidHex: uidHex,
      );

      ctx.dispatch(WriteNtagActionCreator.onUpdateScanResult(
        scannedUid: uidHex,
        fullNdefUrl: fullUrl,
        chipModel: NtagNdefWriter.modelLabel(model),
      ));

      final protected =
          await NtagNdefWriter.isWritePasswordProtected(tag, model);
      _log('write onTag: protected=$protected');
      if (protected) {
        needsUnlock = true;
        pendingUid = uidHex;
        pendingUrl = fullUrl;
        pendingModel = model;
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
          '${NtagNdefWriter.modelLabel(model)} is password-protected.\n'
          'Enter password, then hold the tag again to unlock & rewrite.',
        ));
        return;
      }

      _log('write onTag: writing NDEF…');
      final result = await NtagNdefWriter.writeToTag(
        tag: tag,
        url: fullUrl,
        browserPackages: packages,
        passwordProtect: ctx.state.passwordProtect,
      );
      _log('write onTag: DONE → $result');
      final detail =
          '$result\nUID: $uidHex\nURL: $fullUrl\nAAR: ${packages.join(',')}';
      ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(detail));
      showToast(result);
    },
  );

  if (!needsUnlock) return;

  final entered = await _promptUnlockPassword(ctx.context);
  if (entered == null) {
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
      'Cancelled: password required to rewrite protected tag',
    ));
    return;
  }

  late final List<int> unlockPassword;
  try {
    unlockPassword = NtagNdefWriter.parsePasswordInput(entered);
  } catch (e) {
    showToast('$e');
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('$e'));
    return;
  }

  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
    'Password saved. Hold the same ${NtagNdefWriter.modelLabel(pendingModel)} '
    'again to unlock and rewrite URL + AAR…',
  ));

  // Pass 2: unlock with password, then rewrite URL + packages.
  await _runNfcSession(
    ctx: ctx,
    alertMessage: 'Hold tag again to unlock & write',
    onTag: (tag) async {
      final model = await NtagNdefWriter.detectModel(tag);
      final uidHex = NtagNdefWriter.readTagUidHex(tag);
      if (uidHex == null || uidHex.isEmpty) {
        throw StateError('Failed to read tag UID');
      }
      if (pendingUid != null &&
          uidHex.toUpperCase() != pendingUid!.toUpperCase()) {
        throw StateError(
          'Different tag (expected $pendingUid, got $uidHex). Try again.',
        );
      }

      final fullUrl = pendingUrl ??
          NtagNdefWriter.buildFullNdefUrl(
            domainUrl: domainUrl,
            uidHex: uidHex,
          );

      ctx.dispatch(WriteNtagActionCreator.onUpdateScanResult(
        scannedUid: uidHex,
        fullNdefUrl: fullUrl,
        chipModel: NtagNdefWriter.modelLabel(model),
      ));

      final nfcA = NfcA.from(tag);
      if (nfcA == null) {
        throw StateError('NfcA required to unlock password-protected tag');
      }
      await NtagNdefWriter.passwordAuth(
        nfcA,
        password: unlockPassword,
        expectedPack: null,
      );

      final result = await NtagNdefWriter.writeToTag(
        tag: tag,
        url: fullUrl,
        browserPackages: packages,
        passwordProtect: ctx.state.passwordProtect,
        unlockPassword: unlockPassword,
        alreadyAuthenticated: true,
        newPassword: unlockPassword,
      );
      final detail =
          '$result\nUnlocked + rewritten\nUID: $uidHex\nURL: $fullUrl\n'
          'AAR: ${packages.join(',')}';
      ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(detail));
      showToast(result);
    },
  );
}

/// Returns password string, or null if cancelled.
Future<String?> _promptUnlockPassword(BuildContext context) async {
  final controller = TextEditingController(
    text: NtagNdefWriter.defaultPasswordHex,
  );
  final result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('输入标签密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '该标签已开启写保护。请输入 8 位十六进制密码（或 4 位 ASCII），'
              '确认后请再次贴卡完成解锁并重写 URL / 浏览器包名。',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '43424E54',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (v) {
                if (v.trim().isNotEmpty) {
                  Navigator.of(context).pop(v.trim());
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final v = controller.text.trim();
              if (v.isEmpty) {
                showToast('Please enter password');
                return;
              }
              Navigator.of(context).pop(v);
            },
            child: const Text('Unlock & Write'),
          ),
        ],
      );
    },
  );
  controller.dispose();
  return result;
}

Future<void> _onStartDecode(Action action, Context<WriteNtagState> ctx) async {
  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
    'Hold NTAG to decode: model / UID / URL / AAR…',
  ));

  await _runNfcSession(
    ctx: ctx,
    alertMessage: 'Hold NTAG to decode',
    onTag: (tag) async {
      final decoded = await NtagNdefWriter.decodeTag(tag);
      ctx.dispatch(WriteNtagActionCreator.onUpdateScanResult(
        scannedUid: decoded.uidHex,
        fullNdefUrl: decoded.url ?? '',
        chipModel: NtagNdefWriter.modelLabel(decoded.model),
      ));
      ctx.dispatch(
          WriteNtagActionCreator.onUpdateStatus(decoded.rawSummary));
      showToast('Decode OK: ${NtagNdefWriter.modelLabel(decoded.model)}');
    },
  );
}
