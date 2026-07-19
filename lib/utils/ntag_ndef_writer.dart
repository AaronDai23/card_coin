import 'dart:convert';
import 'dart:typed_data';

import 'package:card_coin/utils/hex_utils.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

/// Builds NDEF for NTAG213-style tags: URI + Android Application Records (AAR).
///
/// AAR order matters: first package is preferred when multiple browsers are listed.
class NtagNdefWriter {
  static const String chromePackage = 'com.android.chrome';
  static const String huaweiBrowserPackage = 'com.huawei.browser';

  /// Read NFC tag UID (hex uppercase), same style as ChipCore / MyCard.
  static String? readTagUidHex(NfcTag tag) {
    final candidates = <Uint8List?>[
      NfcA.from(tag)?.identifier,
      MifareUltralight.from(tag)?.identifier,
      NdefFormatable.from(tag)?.identifier,
      IsoDep.from(tag)?.identifier,
      NfcB.from(tag)?.identifier,
      NfcF.from(tag)?.identifier,
      NfcV.from(tag)?.identifier,
    ];
    for (final id in candidates) {
      if (id != null && id.isNotEmpty) {
        return HexUtils.uint8ListToHex(id).toUpperCase();
      }
    }
    return null;
  }

  /// Same as MyCard: `uid=/` + Base64(UID hex string), matching production links like
  /// `...&uid=/MDQ1OTRGRkFGRTFGOTA=`.
  static String encodeUidParam(String uidHex) {
    final normalized = uidHex.trim().replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    if (normalized.isEmpty) {
      throw ArgumentError('uid is empty');
    }
    return '/${base64Encode(utf8.encode(normalized.toUpperCase()))}';
  }

  /// Build full NDEF URL from server [domainUrl] + scanned [uidHex].
  static String buildFullNdefUrl({
    required String domainUrl,
    required String uidHex,
  }) {
    var base = domainUrl.trim();
    if (base.isEmpty) {
      throw ArgumentError('domainUrl is empty');
    }
    if (!base.startsWith('http://') && !base.startsWith('https://')) {
      base = 'https://$base';
    }

    final uidValue = encodeUidParam(uidHex);

    if (RegExp(r'[?&]uid=/?$').hasMatch(base)) {
      if (base.endsWith('uid=/')) {
        return '$base${uidValue.substring(1)}';
      }
      return '$base$uidValue';
    }

    if (RegExp(r'[?&]uid=').hasMatch(base)) {
      final uri = Uri.parse(base);
      final params = Map<String, String>.from(uri.queryParameters);
      params['uid'] = uidValue;
      return uri.replace(queryParameters: params).toString();
    }

    final sep = base.contains('?') ? '&' : '?';
    return '$base${sep}uid=$uidValue';
  }

  static List<String> parseAarPackages(String? ndefAar) {
    if (ndefAar == null || ndefAar.trim().isEmpty) return const [];
    return ndefAar
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static NdefRecord createAar(String packageName) {
    final pkg = packageName.trim();
    if (pkg.isEmpty) {
      throw ArgumentError('packageName is empty');
    }
    return NdefRecord.createExternal(
      'android.com',
      'pkg',
      Uint8List.fromList(utf8.encode(pkg)),
    );
  }

  static NdefMessage buildMessage({
    required String url,
    required List<String> browserPackages,
  }) {
    final uri = Uri.parse(url.trim());
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError('URL must start with http:// or https://');
    }

    final records = <NdefRecord>[
      NdefRecord.createUri(uri),
    ];
    for (final pkg in browserPackages) {
      final trimmed = pkg.trim();
      if (trimmed.isEmpty) continue;
      records.add(createAar(trimmed));
    }
    return NdefMessage(records);
  }

  static NdefMessage fitToMaxSize(NdefMessage message, int maxSize) {
    if (message.byteLength <= maxSize) return message;
    if (message.records.isEmpty) return message;

    final uriRecord = message.records.first;
    final aars = message.records.skip(1).toList();
    for (var keep = aars.length; keep >= 0; keep--) {
      final candidate = NdefMessage([uriRecord, ...aars.take(keep)]);
      if (candidate.byteLength <= maxSize) {
        return candidate;
      }
    }
    throw StateError(
      'NDEF too large for this tag (need ${message.byteLength}B, max ${maxSize}B). '
      'Shorten the URL or use NTAG215/216.',
    );
  }

  static Future<String> writeToTag({
    required NfcTag tag,
    required String url,
    required List<String> browserPackages,
    required bool lockAfterWrite,
  }) async {
    var message = buildMessage(url: url, browserPackages: browserPackages);

    final ndef = Ndef.from(tag);
    if (ndef != null) {
      if (!ndef.isWritable) {
        throw StateError('Tag is already read-only / locked');
      }
      message = fitToMaxSize(message, ndef.maxSize);
      await ndef.write(message);
      if (lockAfterWrite) {
        await ndef.writeLock();
        return 'Wrote ${message.byteLength}B and locked (read-only)';
      }
      return 'Wrote ${message.byteLength}B (not locked)';
    }

    final formatable = NdefFormatable.from(tag);
    if (formatable != null) {
      const ntag213Budget = 137;
      message = fitToMaxSize(message, ntag213Budget);
      if (lockAfterWrite) {
        await formatable.formatReadOnly(message);
        return 'Formatted, wrote ${message.byteLength}B and locked';
      }
      await formatable.format(message);
      return 'Formatted and wrote ${message.byteLength}B (not locked)';
    }

    throw StateError('Tag does not support NDEF write (not NTAG/NDEF)');
  }
}
