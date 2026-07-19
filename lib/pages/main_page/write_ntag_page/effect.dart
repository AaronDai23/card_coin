import 'dart:async';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/custom_widget/scan_card.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/ntag_ndef_writer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<WriteNtagState>? buildEffect() {
  return combineEffects(<Object, Effect<WriteNtagState>>{
    Lifecycle.initState: _onLoadConfig,
    WriteNtagAction.loadConfig: _onLoadConfig,
    WriteNtagAction.startWrite: _onStartWrite,
    WriteNtagAction.cancelScan: _onCancelScan,
    Lifecycle.dispose: _onDispose,
  });
}

Future<void> _onDispose(Action action, Context<WriteNtagState> ctx) async {
  await _stopSessionSafely();
}

Future<void> _onCancelScan(Action action, Context<WriteNtagState> ctx) async {
  await _stopSessionSafely();
  if (ctx.state.isScanning && Navigator.of(ctx.context).canPop()) {
    Navigator.of(ctx.context).pop();
  }
  ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('Cancelled'));
}

Future<void> _stopSessionSafely() async {
  try {
    await NfcManager.instance.stopSession();
  } catch (_) {}
  try {
    await BlockchainPlatform.instance.resetNfcReaderMode();
  } catch (_) {}
}

/// Same source as MyCard `_loadDomain`: `/smartCard/config` → ndefDomain + ndefAAR.
/// UID is NOT taken here — it comes from NFC scan.
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
      'Config ready. Tap Scan to read UID from tag and write.',
    ));
  } catch (e) {
    ctx.dispatch(WriteNtagActionCreator.onLoadFailed('$e'));
  }
}

Future<void> _onStartWrite(Action action, Context<WriteNtagState> ctx) async {
  final domainUrl = ctx.state.domainUrl.trim();
  final packages = NtagNdefWriter.parseAarPackages(ctx.state.ndefAAR);

  if (domainUrl.isEmpty) {
    showToast('Config not loaded');
    return;
  }
  if (packages.isEmpty) {
    showToast('ndefAAR is empty from server');
    return;
  }

  if (ctx.state.lockAfterWrite) {
    final confirmed = await showDialog<bool>(
      context: ctx.context,
      builder: (context) => AlertDialog(
        title: const Text('Lock tag permanently?'),
        content: const Text(
          'Scan the NTAG to read its UID, write URL + browsers, then lock. '
          'After lock, this tag can never be written again. Continue?',
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
    if (confirmed != true) return;
  }

  final available = await NfcManager.instance.isAvailable();
  if (!available) {
    showToast('NFC is not available');
    return;
  }

  await _stopSessionSafely();
  ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(true));
  ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(
    'Hold phone to NTAG… UID will be read from the tag.',
  ));

  showModalBottomSheet(
    context: ctx.context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    builder: (sheetContext) => ScanCard(
      appLanguageResource: ctx.state.languageResource,
      onCancel: () {
        Navigator.of(sheetContext).pop();
        ctx.dispatch(WriteNtagActionCreator.onCancelScan());
      },
    ),
  );

  var handled = false;
  final timeout = Timer(const Duration(seconds: 45), () async {
    if (handled) return;
    handled = true;
    await _stopSessionSafely();
    if (Navigator.of(ctx.context).canPop()) {
      Navigator.of(ctx.context).pop();
    }
    ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
    ctx.dispatch(WriteNtagActionCreator.onUpdateStatus('Timeout: no tag'));
    showToast('NFC timeout');
  });

  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
    },
    alertMessage: 'Hold your phone near the NTAG213',
    onDiscovered: (NfcTag tag) async {
      if (handled) return;
      handled = true;
      timeout.cancel();
      try {
        final uidHex = NtagNdefWriter.readTagUidHex(tag);
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
        ));

        final result = await NtagNdefWriter.writeToTag(
          tag: tag,
          url: fullUrl,
          browserPackages: packages,
          lockAfterWrite: ctx.state.lockAfterWrite,
        );
        await _stopSessionSafely();
        if (Navigator.of(ctx.context).canPop()) {
          Navigator.of(ctx.context).pop();
        }
        ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
        final detail =
            '$result\nUID: $uidHex\nURL: $fullUrl\nAAR: ${packages.join(',')}';
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(detail));
        showToast(result);
      } catch (e) {
        await _stopSessionSafely();
        if (Navigator.of(ctx.context).canPop()) {
          Navigator.of(ctx.context).pop();
        }
        ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
        final msg = 'Write failed: $e';
        ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
        showToast(msg);
      }
    },
    onError: (NfcError error) async {
      if (handled) return;
      if (error.message.contains('Session invalidated by user')) {
        return;
      }
      handled = true;
      timeout.cancel();
      await _stopSessionSafely();
      if (Navigator.of(ctx.context).canPop()) {
        Navigator.of(ctx.context).pop();
      }
      ctx.dispatch(WriteNtagActionCreator.onUpdateScanning(false));
      final msg = 'NFC error: ${error.message}';
      ctx.dispatch(WriteNtagActionCreator.onUpdateStatus(msg));
      showToast(msg);
    },
  );
}
