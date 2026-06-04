import 'dart:typed_data';

final Uint8List referList = Uint8List.fromList([
  0x30,
  0x31,
  0x32,
  0x33,
  0x34,
  0x35,
  0x36,
  0x37,
  0x38,
  0x39,
  0x41,
  0x42,
  0x43,
  0x44,
  0x45,
  0x46,
]);

class NfcUtil {
  static bool verifySuccess(Uint8List data) {
    var b1 = data[data.length - 2];
    var b2 = data[data.length - 1];
    return b1 == 0x90 && b2 == 0;
  }

  static bool brizziVerifySuccess(Uint8List data) {
    print('========brizziVerifySuccess data:$data');
    var b1 = data[data.length - 2];
    var b2 = data[data.length - 1];
    return b1 == 0x91 && b2 == 0;
  }

  static bool jackVerifySuccess(Uint8List data) {
    var b1 = data[data.length - 2];
    var b2 = data[data.length - 1];
    return b1 == 0x6B && b2 == 0;
  }

  static String getCardNum(Uint8List data, int count) {
    Uint8List list = Uint8List(count * 2);
    int i = 0;
    int j = 0;
    for (var byte in data) {
      if (i >= count) {
        break;
      }
      i++;
      int a = byte & 0XFF;
      int b = j + 1;
      list[j] = referList[a >>> 4];
      j = b + 1;
      list[b] = referList[a & 0x0F];
    }
    return String.fromCharCodes(list);
  }

  static double getAmount(Uint8List data) {
    double amount = 0;
    for (int i = 0; i < 4; i++) {
      amount += (data[i] & 0xFF) << (i * 8);
    }
    return amount;
  }

  static int getAmount2(Uint8List data) {
    int amount = 0;
    int j = 1;
    for (int i = data.length - 1; i >= 0; i--) {
      amount += (data[i] & 255) * j;
      j *= 256;
    }
    return amount;
  }
}
