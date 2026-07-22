import 'dart:async';
import 'dart:io';

import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/ntag_ndef_writer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

void _log(String msg) => debugPrint('NTAGHOME: $msg');

const MethodChannel _nfcChannel = MethodChannel('com.cardcoin.card_coin/nfc');

/// Result of a home-page NTAG scan/write attempt.
class NtagHomeScanResult {
  final bool isSuccess;
  final String? uidHex;
  final String? message;

  /// Tag was not an NTAG213/215/216 — caller should fall back to CPU ChipCore.
  final bool isNotNtag;

  /// User cancelled the scanning sheet.
  final bool isCancelled;

  const NtagHomeScanResult({
    required this.isSuccess,
    this.uidHex,
    this.message,
    this.isNotNtag = false,
    this.isCancelled = false,
  });

  factory NtagHomeScanResult.success(String uidHex) =>
      NtagHomeScanResult(isSuccess: true, uidHex: uidHex);

  factory NtagHomeScanResult.notNtag() => const NtagHomeScanResult(
        isSuccess: false,
        isNotNtag: true,
        message: 'Not an NTAG',
      );

  factory NtagHomeScanResult.cancelled() => const NtagHomeScanResult(
        isSuccess: false,
        isCancelled: true,
        message: 'Session invalidated by user',
      );

  factory NtagHomeScanResult.failure(String message) =>
      NtagHomeScanResult(isSuccess: false, message: message);
}

/// Home-page NTAG write / rewrite using the same logic as WriteNtagPage
/// (detect → unlock if protected → URL+AAR → password protect), with a
/// ChipCore-like half-sheet overlay (not a route, so NFC reader mode stays up).
class NtagHomeScan {
  NtagHomeScan._();

  static Future<void> _setNativeForegroundDispatch(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await _nfcChannel.invokeMethod(
        'setForegroundDispatchEnabled',
        {'enabled': enabled},
      );
    } catch (e) {
      _log('setForegroundDispatchEnabled($enabled) failed: $e');
    }
  }

  static Future<void> _finishSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
    await _setNativeForegroundDispatch(true);
    try {
      await BlockchainPlatform.instance.resetNfcReaderMode();
    } catch (_) {}
  }

  /// Scan one tag and write NDEF (with password unlock/rewrite when needed).
  ///
  /// If [requireNtag] is false and the tag is not NTAG, returns
  /// [NtagHomeScanResult.isNotNtag] so the caller can run ChipCore instead.
  static Future<NtagHomeScanResult> scanAndWrite({
    required BuildContext context,
    required String domainUrl,
    required String ndefAar,
    bool passwordProtect = true,
    bool requireNtag = true,
    String title = 'Ready to Scan',
    String message = 'Please hold your card near the NFC area',
  }) async {
    final domain = domainUrl.trim();
    final packages = NtagNdefWriter.parseAarPackages(ndefAar);
    if (domain.isEmpty) {
      return NtagHomeScanResult.failure('ndefDomain is empty');
    }
    if (packages.isEmpty) {
      return NtagHomeScanResult.failure('ndefAAR is empty');
    }

    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      return NtagHomeScanResult.failure('NFC is not available');
    }

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) {
      return NtagHomeScanResult.failure('Overlay unavailable');
    }

    final completer = Completer<NtagHomeScanResult>();
    void complete(NtagHomeScanResult result) {
      if (!completer.isCompleted) completer.complete(result);
    }

    var handled = false;
    late OverlayEntry entry;

    Future<void> cancel() async {
      if (handled) return;
      handled = true;
      await _finishSession();
      entry.remove();
      complete(NtagHomeScanResult.cancelled());
    }

    entry = OverlayEntry(
      builder: (ctx) => _NfcScanningSheet(
        title: title,
        message: message,
        onCancel: cancel,
      ),
    );
    overlayState.insert(entry);

    final timeout = Timer(const Duration(seconds: 45), () async {
      if (handled) return;
      handled = true;
      await _finishSession();
      entry.remove();
      complete(NtagHomeScanResult.failure('NFC timeout'));
    });

    await _setNativeForegroundDispatch(false);
    NfcManager.instance.stopSession();
    _log('startSession for home NTAG write');
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
      },
      alertMessage: message,
      onDiscovered: (NfcTag tag) async {
        if (handled) return;
        handled = true;
        timeout.cancel();
        NtagHomeScanResult result;
        try {
          result = await _writeOnTag(
            tag: tag,
            domainUrl: domain,
            packages: packages,
            passwordProtect: passwordProtect,
            requireNtag: requireNtag,
          );
        } catch (e) {
          _log('onTag error: $e');
          result = NtagHomeScanResult.failure('$e');
        } finally {
          await _finishSession();
          entry.remove();
        }
        complete(result);
      },
      onError: (NfcError error) async {
        if (handled) return;
        handled = true;
        timeout.cancel();
        await _finishSession();
        entry.remove();
        if (error.message.contains('Session invalidated by user')) {
          complete(NtagHomeScanResult.cancelled());
        } else {
          complete(NtagHomeScanResult.failure(error.message));
        }
      },
    );

    return completer.future;
  }

  static Future<NtagHomeScanResult> _writeOnTag({
    required NfcTag tag,
    required String domainUrl,
    required List<String> packages,
    required bool passwordProtect,
    required bool requireNtag,
  }) async {
    final model = await NtagNdefWriter.detectModel(tag);
    _log('model=${NtagNdefWriter.modelLabel(model)} keys=${tag.data.keys}');
    if (model == NtagModel.unknown) {
      if (!requireNtag) return NtagHomeScanResult.notNtag();
      return NtagHomeScanResult.failure('Unsupported tag (expected NTAG213/215)');
    }

    final uidHex = NtagNdefWriter.readTagUidHex(tag);
    if (uidHex == null || uidHex.isEmpty) {
      return NtagHomeScanResult.failure('Failed to read tag UID');
    }

    final fullUrl = NtagNdefWriter.buildFullNdefUrl(
      domainUrl: domainUrl,
      uidHex: uidHex,
    );
    const password = NtagNdefWriter.defaultPasswordBytes;

    final cfg = await NtagNdefWriter.readConfigBlock(tag, model);
    final protected = NtagNdefWriter.isProtectedFromConfig(cfg, model);
    _log('uid=$uidHex protected=$protected');

    if (protected) {
      final nfcA = NfcA.from(tag);
      if (nfcA == null) {
        return NtagHomeScanResult.failure('NfcA required to unlock protected tag');
      }
      await NtagNdefWriter.passwordAuth(
        nfcA,
        password: password,
        expectedPack: null,
      );
    }

    await NtagNdefWriter.writeToTag(
      tag: tag,
      url: fullUrl,
      browserPackages: packages,
      passwordProtect: passwordProtect,
      alreadyAuthenticated: protected,
      newPassword: password,
    );
    _log('write OK uid=$uidHex');
    return NtagHomeScanResult.success(uidHex);
  }
}

/// Half-sheet overlay that visually matches ChipCore's NFC BottomSheetDialog.
class _NfcScanningSheet extends StatelessWidget {
  final String title;
  final String message;
  final Future<void> Function() onCancel;

  const _NfcScanningSheet({
    required this.title,
    required this.message,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.5;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          const ModalBarrier(color: Colors.black54, dismissible: false),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: sheetHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📲', style: TextStyle(fontSize: 56)),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 8),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => onCancel(),
                          child: const Text(
                            '取消',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
