import 'dart:convert';
import 'dart:typed_data';

import 'package:card_coin/utils/hex_utils.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

enum NtagModel {
  ntag213,
  ntag215,
  ntag216,
  unknown,
}

/// Config page addresses for NXP NTAG Type 2 (from NXP datasheet).
class NtagConfigPages {
  final int auth0;
  final int access;
  final int pwd;
  final int pack;
  final int userCapacityHint;

  const NtagConfigPages({
    required this.auth0,
    required this.access,
    required this.pwd,
    required this.pack,
    required this.userCapacityHint,
  });

  static const ntag213 = NtagConfigPages(
    auth0: 0x29,
    access: 0x2A,
    pwd: 0x2B,
    pack: 0x2C,
    userCapacityHint: 144,
  );

  static const ntag215 = NtagConfigPages(
    auth0: 0x83,
    access: 0x84,
    pwd: 0x85,
    pack: 0x86,
    userCapacityHint: 504,
  );

  static const ntag216 = NtagConfigPages(
    auth0: 0xE3,
    access: 0xE4,
    pwd: 0xE5,
    pack: 0xE6,
    userCapacityHint: 888,
  );

  static NtagConfigPages forModel(NtagModel model) {
    switch (model) {
      case NtagModel.ntag213:
        return ntag213;
      case NtagModel.ntag215:
        return ntag215;
      case NtagModel.ntag216:
        return ntag216;
      case NtagModel.unknown:
        return ntag213;
    }
  }
}

class NtagDecodeResult {
  final NtagModel model;
  final String uidHex;
  final String? url;
  final String? uidFromUrl;
  final List<String> browserPackages;
  final String rawSummary;

  const NtagDecodeResult({
    required this.model,
    required this.uidHex,
    required this.url,
    required this.uidFromUrl,
    required this.browserPackages,
    required this.rawSummary,
  });
}

/// NDEF URI + AAR write/read for NTAG213/215, with optional password write-protect
/// (reversible) instead of permanent [Ndef.writeLock].
class NtagNdefWriter {
  static const String chromePackage = 'com.android.chrome';
  static const String huaweiBrowserPackage = 'com.huawei.browser';

  /// App write-password (4 bytes). Change carefully — needed to rewrite later.
  static const List<int> defaultPasswordBytes = [0x43, 0x42, 0x4E, 0x54]; // CBNT

  /// PACK returned after successful PWD_AUTH (2 bytes + 2 RFUI on page).
  static const List<int> defaultPackBytes = [0x80, 0x80];

  static String get defaultPasswordHex =>
      HexUtils.uint8ListToHex(Uint8List.fromList(defaultPasswordBytes));

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

  static Future<NtagModel> detectModel(NfcTag tag) async {
    final nfcA = NfcA.from(tag);
    if (nfcA == null) return NtagModel.unknown;
    try {
      final resp =
          await nfcA.transceive(data: Uint8List.fromList([0x60])); // GET_VERSION
      if (resp.length < 8) return NtagModel.unknown;
      // Byte6 = storage size encoding (NXP): 0x0F=213, 0x11=215, 0x13=216
      switch (resp[6]) {
        case 0x0F:
          return NtagModel.ntag213;
        case 0x11:
          return NtagModel.ntag215;
        case 0x13:
          return NtagModel.ntag216;
        default:
          return NtagModel.unknown;
      }
    } catch (_) {
      return NtagModel.unknown;
    }
  }

  static String modelLabel(NtagModel model) {
    switch (model) {
      case NtagModel.ntag213:
        return 'NTAG213';
      case NtagModel.ntag215:
        return 'NTAG215';
      case NtagModel.ntag216:
        return 'NTAG216';
      case NtagModel.unknown:
        return 'Unknown NTAG';
    }
  }

  static String encodeUidParam(String uidHex) {
    final normalized = uidHex.trim().replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    if (normalized.isEmpty) {
      throw ArgumentError('uid is empty');
    }
    return '/${base64Encode(utf8.encode(normalized.toUpperCase()))}';
  }

  /// Decode `uid=/BASE64` or `uid=BASE64` from a full NDEF URL back to hex.
  static String? decodeUidFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      var raw = uri.queryParameters['uid'];
      if (raw == null || raw.isEmpty) return null;
      if (raw.startsWith('/')) raw = raw.substring(1);
      final bytes = base64Decode(raw);
      return utf8.decode(bytes).toUpperCase();
    } catch (_) {
      return null;
    }
  }

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

  /// URI record WITHOUT prefix abbreviation (identifier byte 0x00), so the
  /// full literal `https://...` is stored in the tag payload instead of being
  /// compressed to the `https://` prefix code (0x04).
  static NdefRecord createUriLiteral(String url) {
    final full = url.trim();
    if (full.isEmpty) {
      throw ArgumentError('url is empty');
    }
    return NdefRecord(
      typeNameFormat: NdefTypeNameFormat.nfcWellknown,
      type: Uint8List.fromList([0x55]),
      identifier: Uint8List.fromList([]),
      payload: Uint8List.fromList([0x00, ...utf8.encode(full)]),
    );
  }

  static NdefMessage buildMessage({
    required String url,
    required List<String> browserPackages,
  }) {
    final normalized = url.trim();
    final uri = Uri.parse(normalized);
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError('URL must start with http:// or https://');
    }

    final records = <NdefRecord>[
      // Write the full literal URL (with https://) into the tag.
      createUriLiteral(normalized),
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
      'Use NTAG215/216 or shorten URL / fewer AARs.',
    );
  }

  static int _budgetFor(NtagModel model, int? ndefMaxSize) {
    if (ndefMaxSize != null && ndefMaxSize > 0) return ndefMaxSize;
    return NtagConfigPages.forModel(model).userCapacityHint - 7;
  }

  /// Parse 4-byte PWD from hex (8 chars) or ASCII (exactly 4 chars).
  static List<int> parsePasswordInput(String input) {
    final raw = input.trim();
    if (raw.isEmpty) {
      throw ArgumentError('Password is empty');
    }
    final hex = raw.replaceAll(RegExp(r'[\s:-]'), '');
    if (RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(hex)) {
      final out = <int>[];
      for (var i = 0; i < 8; i += 2) {
        out.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }
      return out;
    }
    if (raw.length == 4) {
      return utf8.encode(raw);
    }
    throw ArgumentError(
      'Password must be 8 hex chars (e.g. $defaultPasswordHex) or 4 ASCII chars',
    );
  }

  /// True when AUTH0 enables password from user memory (factory default 0xFF = off).
  static Future<bool> isWritePasswordProtected(
    NfcTag tag,
    NtagModel model,
  ) async {
    if (model == NtagModel.unknown) return false;
    final nfcA = NfcA.from(tag);
    if (nfcA == null) return false;
    try {
      final pages = NtagConfigPages.forModel(model);
      // READ (0x30) returns 16 bytes starting at page.
      final resp = await nfcA.transceive(
        data: Uint8List.fromList([0x30, pages.auth0]),
      );
      if (resp.isEmpty) return false;
      final auth0 = resp[0];
      // 0xFF = disabled. Values covering user pages (from page 4) mean protect ON.
      return auth0 != 0xFF && auth0 <= 0xEB;
    } catch (_) {
      return false;
    }
  }

  /// Authenticate with PWD (needed before rewrite when write-protect is on).
  /// If [expectedPack] is null, any 2-byte PACK response is treated as success.
  static Future<void> passwordAuth(
    NfcA nfcA, {
    List<int> password = defaultPasswordBytes,
    List<int>? expectedPack = defaultPackBytes,
  }) async {
    if (password.length != 4) {
      throw ArgumentError('NTAG password must be 4 bytes');
    }
    final cmd = Uint8List.fromList([0x1B, ...password]);
    final resp = await nfcA.transceive(data: cmd);
    if (resp.length < 2) {
      throw StateError('PWD_AUTH failed: wrong password or empty PACK');
    }
    if (expectedPack != null &&
        expectedPack.length >= 2 &&
        (resp[0] != expectedPack[0] || resp[1] != expectedPack[1])) {
      throw StateError(
        'PWD_AUTH failed: unexpected PACK '
        '${HexUtils.uint8ListToHex(resp.sublist(0, 2))} '
        '(password may be wrong)',
      );
    }
  }

  static Future<void> _writePage(NfcA nfcA, int page, List<int> fourBytes) async {
    if (fourBytes.length != 4) {
      throw ArgumentError('page data must be 4 bytes');
    }
    await nfcA.transceive(
        data: Uint8List.fromList([0xA2, page, ...fourBytes]));
  }

  /// Enable write-password protection (PROT=0: read free, write needs PWD).
  /// Call AFTER NDEF content is written. Do NOT call permanent writeLock.
  static Future<void> enablePasswordWriteProtect(
    NfcTag tag,
    NtagModel model, {
    List<int> password = defaultPasswordBytes,
    List<int> pack = defaultPackBytes,
  }) async {
    final nfcA = NfcA.from(tag);
    if (nfcA == null) {
      throw StateError('NfcA required for password protect');
    }
    if (model == NtagModel.unknown) {
      throw StateError('Unsupported / unknown NTAG model for password protect');
    }
    final pages = NtagConfigPages.forModel(model);

    // Order: PWD → PACK → ACCESS → AUTH0 (activate last).
    await _writePage(nfcA, pages.pwd, password);
    await _writePage(nfcA, pages.pack, [...pack, 0x00, 0x00]);
    // ACCESS: PROT=0 (bit7=0) write-only password protect; AUTHLIM=0
    await _writePage(nfcA, pages.access, [0x00, 0x00, 0x00, 0x00]);
    // AUTH0 = 0x04 → protect from user memory page 4 upward
    await _writePage(nfcA, pages.auth0, [0x00, 0x00, 0x00, 0x04]);
  }

  /// Write URL + AAR for detected 213/215(/216), optionally password-protect.
  ///
  /// When the tag is already write-protected, pass [unlockPassword] after a
  /// successful [passwordAuth] (or set [alreadyAuthenticated]).
  static Future<String> writeToTag({
    required NfcTag tag,
    required String url,
    required List<String> browserPackages,
    required bool passwordProtect,
    List<int>? unlockPassword,
    bool alreadyAuthenticated = false,
    List<int> newPassword = defaultPasswordBytes,
  }) async {
    final model = await detectModel(tag);
    final modelName = modelLabel(model);
    var message = buildMessage(url: url, browserPackages: browserPackages);

    final nfcA = NfcA.from(tag);
    if (!alreadyAuthenticated && unlockPassword != null && nfcA != null) {
      await passwordAuth(
        nfcA,
        password: unlockPassword,
        expectedPack: null,
      );
    }

    final ndef = Ndef.from(tag);
    if (ndef != null) {
      if (!ndef.isWritable) {
        throw StateError(
          'Tag reports not writable (permanent lock or missing auth). '
          'If password-protected, unlock with PWD first; permanent lock cannot be undone.',
        );
      }
      final budget = _budgetFor(model, ndef.maxSize);
      message = fitToMaxSize(message, budget);
      await ndef.write(message);
    } else {
      final formatable = NdefFormatable.from(tag);
      if (formatable == null) {
        throw StateError('Tag does not support NDEF write ($modelName)');
      }
      final budget = _budgetFor(model, null);
      message = fitToMaxSize(message, budget);
      await formatable.format(message);
    }

    var protectNote = 'no password protect';
    if (passwordProtect) {
      if (model == NtagModel.unknown) {
        protectNote = 'skipped password (unknown model)';
      } else {
        // After PWD_AUTH, config pages are writable — re-apply protect.
        await enablePasswordWriteProtect(
          tag,
          model,
          password: newPassword,
        );
        protectNote = 'password write-protect ON (read free)';
      }
    }

    return '$modelName: wrote ${message.byteLength}B, $protectNote';
  }

  /// Read/decode NDEF: URL, uid from query, browser AAR packages.
  static Future<NtagDecodeResult> decodeTag(NfcTag tag) async {
    final model = await detectModel(tag);
    final uidHex = readTagUidHex(tag) ?? '';

    NdefMessage? message;
    final ndef = Ndef.from(tag);
    if (ndef != null) {
      try {
        message = await ndef.read();
      } catch (_) {
        message = ndef.cachedMessage;
      }
    }

    String? url;
    final packages = <String>[];
    final lines = <String>[];

    if (message != null) {
      for (final record in message.records) {
        if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
            record.type.isNotEmpty &&
            record.type[0] == 0x55) {
          // URI
          final payload = record.payload;
          if (payload.isNotEmpty) {
            final prefixIndex = payload[0];
            final prefix = prefixIndex < NdefRecord.URI_PREFIX_LIST.length
                ? NdefRecord.URI_PREFIX_LIST[prefixIndex]
                : '';
            url = prefix + utf8.decode(payload.sublist(1));
            lines.add('URI: $url');
          }
        } else if (record.typeNameFormat == NdefTypeNameFormat.nfcExternal) {
          final typeStr = utf8.decode(record.type);
          if (typeStr == 'android.com:pkg') {
            final pkg = utf8.decode(record.payload);
            packages.add(pkg);
            lines.add('AAR: $pkg');
          } else {
            lines.add('External: $typeStr');
          }
        } else {
          lines.add(
            'Record TNF=${record.typeNameFormat} type=${utf8.decode(record.type, allowMalformed: true)}',
          );
        }
      }
    } else {
      lines.add('No NDEF message readable');
    }

    final uidFromUrl = url == null ? null : decodeUidFromUrl(url);
    if (uidFromUrl != null) {
      lines.add('UID from URL: $uidFromUrl');
    }
    lines.insert(0, 'Model: ${modelLabel(model)}');
    lines.insert(1, 'Tag UID: $uidHex');

    return NtagDecodeResult(
      model: model,
      uidHex: uidHex,
      url: url,
      uidFromUrl: uidFromUrl,
      browserPackages: packages,
      rawSummary: lines.join('\n'),
    );
  }
}
