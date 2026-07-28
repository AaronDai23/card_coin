import 'dart:typed_data';

import 'package:card_coin/utils/ntag_ndef_writer.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

/// Mifare Classic helpers for NDEF health-check / write-key lock detection.
///
/// Classic has no NTAG PWD_AUTH. Real write-protect = app KeyB **and** access
/// bits `78 77 88` (KeyA read-only). Forum `7F 07 88` still allows KeyA write.
class MifareClassicUtil {
  /// Same secret as Kotlin [MifareClassicNdefWriter.DEFAULT_WRITE_KEY].
  static Uint8List get writeKeyBytes => Uint8List.fromList([
        ...NtagNdefWriter.defaultPasswordBytes,
        ...NtagNdefWriter.defaultPackBytes,
      ]);

  static final Uint8List keyDefault =
      Uint8List.fromList([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]);

  static final Uint8List keyNfcForum =
      Uint8List.fromList([0xD3, 0xF7, 0xD3, 0xF7, 0xD3, 0xF7]);

  static final Uint8List keyMad =
      Uint8List.fromList([0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5]);

  static Uint8List getDefaultKey(bool enableNdef, int sectorIndex) {
    if (!enableNdef) return keyDefault;
    return sectorIndex == 0 ? keyMad : keyNfcForum;
  }

  /// Access bits: KeyA read / KeyB write only (real protect).
  static final Uint8List accessKeyBWriteOnly =
      Uint8List.fromList([0x78, 0x77, 0x88]);

  /// NFC Forum public READ/WRITE — KeyA can still overwrite (NFC Tools works).
  static final Uint8List accessForumPublicRw =
      Uint8List.fromList([0x7F, 0x07, 0x88]);

  static int getBlockIndex(int sectorIndex, int sectorBlockIndex) {
    return sectorIndex * 4 + sectorBlockIndex;
  }

  static bool isClassicTag(NfcTag tag) => MifareClassic.from(tag) != null;

  static String? readUidHex(NfcTag tag) {
    final id = MifareClassic.from(tag)?.identifier ?? NfcA.from(tag)?.identifier;
    if (id == null || id.isEmpty) return null;
    return id.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  /// True only when app KeyB works **and** access bits are `78 77 88`.
  ///
  /// `7F 07 88` + our KeyB is NOT locked — KeyA (`D3F7…`) can still write.
  static Future<bool> isWriteKeyProtected(
    MifareClassic mfc, {
    int sectorIndex = 1,
  }) async {
    final probe = await probeWriteProtect(mfc, sectorIndex: sectorIndex);
    return probe.isLocked;
  }

  /// Detailed Classic write-protect probe for health check UI.
  static Future<ClassicLockProbe> probeWriteProtect(
    MifareClassic mfc, {
    int sectorIndex = 1,
  }) async {
    final withWriteKey = await _tryAuthKeyB(mfc, sectorIndex, writeKeyBytes);
    if (!withWriteKey) {
      return const ClassicLockProbe(
        isLocked: false,
        label: 'No',
        accessHex: null,
        detail: 'app KeyB auth failed',
      );
    }

    Uint8List? access;
    try {
      // 1K: trailer = sector*4+3. (4K high sectors differ; health uses sector 1.)
      final trailerBlock =
          sectorIndex < 32 ? sectorIndex * 4 + 3 : 128 + (sectorIndex - 32) * 16 + 15;
      final trailer = await mfc.readBlock(blockIndex: trailerBlock);
      if (trailer.length >= 9) {
        access = Uint8List.fromList(trailer.sublist(6, 9));
      }
    } catch (e) {
      return ClassicLockProbe(
        isLocked: false,
        label: 'Unknown',
        accessHex: null,
        detail: 'trailer read failed: $e',
      );
    }

    final accessHex = access
        ?.map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();

    if (access != null && _bytesEqual(access, accessKeyBWriteOnly)) {
      return ClassicLockProbe(
        isLocked: true,
        label: 'Yes',
        accessHex: accessHex,
        detail: '787788 KeyB-only write',
      );
    }
    if (access != null && _bytesEqual(access, accessForumPublicRw)) {
      // KeyB set but Forum RW — NFC Tools can still overwrite via KeyA.
      return ClassicLockProbe(
        isLocked: false,
        label: 'No',
        accessHex: accessHex,
        detail: '7F0788 KeyA still writable',
      );
    }
    return ClassicLockProbe(
      isLocked: false,
      label: 'No',
      accessHex: accessHex,
      detail: 'unexpected access $accessHex',
    );
  }

  static bool _bytesEqual(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Best-effort NDEF URI from platform [Ndef] or raw Classic TLV (sector 1+).
  static Future<String?> readNdefUrl(NfcTag tag) async {
    try {
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        final message = ndef.cachedMessage ?? await ndef.read();
        for (final record in message.records) {
          final url = _uriFromRecord(record);
          if (url != null && url.isNotEmpty) return url;
        }
      }
    } catch (_) {}

    final mfc = MifareClassic.from(tag);
    if (mfc == null) return null;
    try {
      return await _readUrlFromClassicTlv(mfc);
    } catch (e) {
      print('Classic TLV NDEF read failed: $e');
      return null;
    }
  }

  static Future<bool> _tryAuthKeyB(
    MifareClassic mfc,
    int sectorIndex,
    Uint8List key,
  ) async {
    try {
      return await mfc.authenticateSectorWithKeyB(
        sectorIndex: sectorIndex,
        key: key,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _tryAuthKeyA(
    MifareClassic mfc,
    int sectorIndex,
    Uint8List key,
  ) async {
    try {
      return await mfc.authenticateSectorWithKeyA(
        sectorIndex: sectorIndex,
        key: key,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<String?> _readUrlFromClassicTlv(MifareClassic mfc) async {
    final sectorCount = mfc.sectorCount.clamp(0, 16);
    if (sectorCount < 2) return null;

    // Prefer KeyA NFC Forum (public read after our format).
    final keysA = [keyNfcForum, keyDefault, writeKeyBytes, keyMad];
    final chunks = <int>[];
    for (var sector = 1; sector < sectorCount; sector++) {
      var authed = false;
      for (final key in keysA) {
        if (await _tryAuthKeyA(mfc, sector, key)) {
          authed = true;
          break;
        }
      }
      if (!authed) {
        for (final key in [writeKeyBytes, keyDefault, keyNfcForum]) {
          if (await _tryAuthKeyB(mfc, sector, key)) {
            authed = true;
            break;
          }
        }
      }
      if (!authed) break;

      // Classic 1K: 3 data blocks / sector. 4K high sectors have 15 — still OK
      // to read first 3 via blockIndex = sector*4 + b for sector < 16 on 1K;
      // use sectorToBlock math: for sector < 32, blockIndex = sector*4.
      final firstBlock = sector < 32 ? sector * 4 : 128 + (sector - 32) * 16;
      final dataBlocks = sector < 32 ? 3 : 15;
      for (var b = 0; b < dataBlocks; b++) {
        final block = await mfc.readBlock(blockIndex: firstBlock + b);
        chunks.addAll(block);
      }
      // Stop early once TLV terminator seen.
      if (chunks.contains(0xFE) && chunks.contains(0x03)) {
        final url = _urlFromTlv(Uint8List.fromList(chunks));
        if (url != null) return url;
      }
    }
    return _urlFromTlv(Uint8List.fromList(chunks));
  }

  static String? _urlFromTlv(Uint8List data) {
    // Find NDEF TLV type 0x03
    var i = 0;
    while (i < data.length) {
      final t = data[i];
      if (t == 0x00) {
        i++;
        continue;
      }
      if (t == 0xFE) break;
      if (i + 1 >= data.length) break;
      var len = data[i + 1];
      var header = 2;
      if (len == 0xFF) {
        if (i + 3 >= data.length) break;
        len = (data[i + 2] << 8) | data[i + 3];
        header = 4;
      }
      if (t == 0x03) {
        final start = i + header;
        final end = (start + len).clamp(0, data.length);
        return _urlFromNdefMessage(data.sublist(start, end));
      }
      i += header + len;
    }
    return null;
  }

  static String? _urlFromNdefMessage(List<int> ndef) {
    // Minimal well-known URI record parse: D1 01 <plen> 55 <prefix> <rest>
    // or TNF=1 short record with type 'U'.
    var i = 0;
    while (i + 3 < ndef.length) {
      final header = ndef[i];
      final tnf = header & 0x07;
      final sr = (header & 0x10) != 0;
      final il = (header & 0x08) != 0;
      final typeLen = ndef[i + 1];
      int payloadLen;
      var o = i + 2;
      if (sr) {
        payloadLen = ndef[o++];
      } else {
        if (o + 3 >= ndef.length) break;
        payloadLen = (ndef[o] << 24) |
            (ndef[o + 1] << 16) |
            (ndef[o + 2] << 8) |
            ndef[o + 3];
        o += 4;
      }
      if (il) {
        if (o >= ndef.length) break;
        o += 1 + ndef[o]; // skip id length + id
      }
      if (o + typeLen > ndef.length) break;
      final type = ndef.sublist(o, o + typeLen);
      o += typeLen;
      if (o + payloadLen > ndef.length) break;
      final payload = ndef.sublist(o, o + payloadLen);
      o += payloadLen;

      if (tnf == 0x01 &&
          typeLen == 1 &&
          type[0] == 0x55 &&
          payload.isNotEmpty) {
        final prefixIndex = payload[0];
        const prefixes = NdefRecord.URI_PREFIX_LIST;
        final prefix = prefixIndex < prefixes.length ? prefixes[prefixIndex] : '';
        return prefix + String.fromCharCodes(payload.sublist(1));
      }
      i = o;
      if ((header & 0x40) != 0) break; // ME
    }
    return null;
  }

  static String? _uriFromRecord(NdefRecord record) {
    if (record.typeNameFormat != NdefTypeNameFormat.nfcWellknown) return null;
    if (record.type.isEmpty || record.type[0] != 0x55) return null;
    final payload = record.payload;
    if (payload.isEmpty) return null;
    final prefixIndex = payload[0];
    final prefix = prefixIndex < NdefRecord.URI_PREFIX_LIST.length
        ? NdefRecord.URI_PREFIX_LIST[prefixIndex]
        : '';
    return prefix + String.fromCharCodes(payload.sublist(1));
  }
}

/// Result of Classic write-protect probe (health check / diagnostics).
class ClassicLockProbe {
  const ClassicLockProbe({
    required this.isLocked,
    required this.label,
    required this.accessHex,
    required this.detail,
  });

  final bool isLocked;

  /// UI value: `Yes` / `No` / `Unknown`.
  final String label;
  final String? accessHex;
  final String detail;
}
