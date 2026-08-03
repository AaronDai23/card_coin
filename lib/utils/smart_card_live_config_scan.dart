import 'package:chipcore_sdk/src/demo/utils/scan_util.dart' as chip_scan;
import 'package:chipcore_sdk/src/pigeon/messages.dart';
import 'package:flutter/services.dart';

/// Live smartCard/config + NFC write, owned by card_coin.
///
/// One NFC dialog (iOS & Android): native reads uid → Flutter HTTP config →
/// native writes NDEF on the same session. iOS keeps RF alive with Type2
/// READ pings during the HTTP wait (see chipcore_sdk NfcCardSession).
class SmartCardLiveConfigScan {
  static const MethodChannel _channel =
      MethodChannel('com.chipcore.sdk/nfc_session');

  /// [fetchConfigMap] must return keys understood by native:
  /// `ndefDomain`, `ndefAar`/`ndefAAR`, `isNeedSyncUid`, `writeNdef`,
  /// `needsWriteConfirm`.
  static Future<chip_scan.ScanResponse<CommandResponse>> run({
    required Future<Map<String, dynamic>> Function(String uid) fetchConfigMap,
    bool checkLock = true,
    bool needSyncUid = true,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'fetchSmartCardConfig') {
        throw MissingPluginException(call.method);
      }
      final args = call.arguments;
      final uid = args is Map ? (args['uid'] as String? ?? '') : '';
      if (uid.isEmpty) {
        throw PlatformException(code: 'config-error', message: 'uid is empty');
      }
      final map = await fetchConfigMap(uid);
      // ignore: avoid_print
      print(
        '[NDEF] step2→native uid=$uid url=${map['ndefDomain']} '
        'writeNdef=${map['writeNdef']} needsConfirm=${map['needsWriteConfirm']}',
      );
      return map;
    });
    try {
      return await chip_scan.ScanUtil.scanOnly(
        checkLock: checkLock,
        needSyncUid: needSyncUid,
        ndefLink: chip_scan.ScanUtil.resolveSmartCardConfigSentinel,
      );
    } finally {
      _channel.setMethodCallHandler(null);
    }
  }
}
