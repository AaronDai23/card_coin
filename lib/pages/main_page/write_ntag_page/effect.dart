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

/// Set while a scan session is running so [_onCancelScan] can resolve the
/// in-flight [_runNfcSession] future (Android cancel does not fire onError).
void Function()? _cancelActiveSession;

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
  _cancelActiveSession?.call();
}

/// Full cleanup AFTER a session ends: stop the reader session and reset the
/// app's native NFC reader mode. Never call this immediately before
/// `startSession`.
Future<void> _finishSession() async {
  try {
    await NfcManager.instance.stopSession();
  } catch (_) {}
  // Re-enable Activity foreground dispatch ASAP after reader mode stops.
  // While both are off, Android's default NDEF dispatch sees the still-present
  // tag (URL + browser AAR) and launches Chrome/Huawei Browser. With FD on,
  // MainActivity.onNewIntent swallows the NFC intent instead.
  await _setNativeForegroundDispatch(true);
  try {
    await BlockchainPlatform.instance.resetNfcReaderMode();
  } catch (_) {}
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

  // Resolve only when this scan actually finishes (tag handled / error /
  // timeout), so callers can await the result and run follow-up steps such as
  // the password-unlock second pass. Without this, startSession returns
  // immediately (before the tap) and any post-scan logic is skipped.
  final completer = Completer<void>();
  void done() {
    _cancelActiveSession = null;
    if (!completer.isCompleted) completer.complete();
  }

  var handled = false;
  _cancelActiveSession = () {
    if (handled) return;
    handled = true;
    done();
  };
  final timeout = Timer(const Duration(seconds: 45), () async {
    if (handled) return;
    handled = true;
    await _finishSession();
    ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('Timeout: no tag'));
    showToast('NFC timeout');
    done();
  });

  // Disable the native foreground dispatch BEFORE enabling reader mode, so the
  // two NFC paths don't both fire on the same tap (which churns Activity focus
  // and breaks the tag connection mid-write). Restored on page dispose.
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
      } catch (e) {
        _log('onDiscovered/onTag error: $e');
        final msg = '$e';
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
        showToast(msg);
      } finally {
        await _finishSession();
        ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
        done();
      }
    },
    onError: (NfcError error) async {
      _log('onError: type=${error.type} msg=${error.message}');
      if (handled) return;
      handled = true;
      timeout.cancel();
      await _finishSession();
      ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
      if (!error.message.contains('Session invalidated by user')) {
        final msg = 'NFC error: ${error.message}';
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
        showToast(msg);
      }
      done();
    },
  );

  return completer.future;
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

  // Always use the app's default password — no dialog. If the tag is already
  // protected (by us), we auto-authenticate with this same default password in
  // the SAME tap/session, so protected tags behave exactly like a first write.
  final password = NtagNdefWriter.defaultPasswordBytes;

  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
    'Hold NTAG… detect 213/215 → (unlock if protected) → write URL+AAR'
    '${ctx.state.passwordProtect ? ' → password protect' : ''}',
  ));

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

      // Read raw config so we can see the real AUTH0 (byte 3 of CFG0).
      final cfg = await NtagNdefWriter.readConfigBlock(tag, model);
      _log('write onTag: cfg=${cfg == null ? 'null' : _hex(cfg)}');
      final protected = NtagNdefWriter.isProtectedFromConfig(cfg, model);
      _log('write onTag: protected=$protected '
          '(auth0=${cfg != null && cfg.length >= 4 ? cfg[3].toRadixString(16) : '?'})');

      // If protected, authenticate in the SAME session (no stop / rescan).
      if (protected) {
        final nfcA = NfcA.from(tag);
        if (nfcA == null) {
          throw StateError('NfcA required to unlock protected tag');
        }
        _log('write onTag: PWD_AUTH…');
        await NtagNdefWriter.passwordAuth(
          nfcA,
          password: password,
          expectedPack: null,
        );
        _log('write onTag: PWD_AUTH ok');
      }

      _log('write onTag: writing NDEF…');
      final result = await NtagNdefWriter.writeToTag(
        tag: tag,
        url: fullUrl,
        browserPackages: packages,
        passwordProtect: ctx.state.passwordProtect,
        alreadyAuthenticated: protected,
        newPassword: password,
      );
      _log('write onTag: DONE → $result');
      final detail = '$result\nUID: $uidHex\nURL: $fullUrl\n'
          'AAR: ${packages.join(',')}'
          '${protected ? '\nUnlocked with password before rewrite' : ''}';
      ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(detail));
      showToast(result);
    },
  );
}

String _hex(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');

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
