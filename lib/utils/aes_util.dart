import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class AesUtil {
  /// AES 加密
  static Uint8List encryptData(List<int> key, Uint8List originHex) {
    final keyOxo = Key(Uint8List.fromList(key));
    final encryptor = Encrypter(AES(keyOxo, mode: AESMode.cbc));
    final encryptedOld =
        encryptor.encryptBytes(originHex, iv: IV(Uint8List.fromList(key)));
    return encryptedOld.bytes;
  }

  /// AES 解密
  static Uint8List decryptData(List<int> key, Uint8List encryptorData) {
    if (encryptorData.isEmpty) {
      return encryptorData;
    }
    final keyOxo = Key(Uint8List.fromList(key));
    final encryptor = Encrypter(AES(keyOxo, mode: AESMode.cbc));

    final encrypted = Encrypted(encryptorData);
    final decryptedOld = Uint8List.fromList(
        encryptor.decryptBytes(encrypted, iv: IV(Uint8List.fromList(key))));

    return decryptedOld;
  }
}
