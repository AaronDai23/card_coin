import 'dart:typed_data';
import 'package:card_coin/card_base/managers/isodep_reader_manager.dart';
import 'package:flutter/material.dart';
import '../utils/nfc_util.dart';

const List<int> emoneyBytes = [
  0,
  -92,
  4,
  0,
  8,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
  -77,
  0,
  0,
  63,
  0,
  -75,
  0,
  0,
  10,
  0,
  -78,
  0,
  0,
  40
];
const List<int> flazzBytes = [
  0,
  -92,
  4,
  0,
  11,
  -96,
  0,
  0,
  0,
  24,
  15,
  0,
  0,
  1,
  -128,
  1,
  0,
  -92,
  1,
  0,
  2,
  2,
  0,
  0,
  -80,
  -127,
  0,
  -114
];
const List<int> brizziBytes = [
  -112,
  90,
  0,
  0,
  3,
  1,
  0,
  0,
  0,
  -112,
  -67,
  0,
  0,
  7,
  0,
  0,
  0,
  0,
  23,
  0,
  0,
  0,
  -112,
  108,
  0,
  0,
  1,
  0,
  0
];
const List<int> tapBytes = [
  0,
  -92,
  4,
  0,
  8,
  -96,
  0,
  66,
  78,
  73,
  16,
  0,
  1,
  -112,
  50,
  3,
  0,
  0,
  -112,
  50,
  3,
  0,
  1
];
const List<int> jackBytes = [
  0,
  -92,
  4,
  0,
  8,
  -96,
  0,
  66,
  78,
  73,
  16,
  0,
  1,
  -112,
  50,
  3,
  0,
  0,
  -112,
  50,
  3,
  0,
  1
];

abstract class BaseCardInfo {
  String? identifier;
  int? amount;
  String? cardNum;
  String get name;
  String get brand;
  String get logo;
  Color get color;

  final CommandApi? _commandApi;

  BaseCardInfo(CommandApi? commandApi) : _commandApi = commandApi;

  requestData();
}

class EmoneyCardInfo extends BaseCardInfo {
  final Uint8List _commandDatas = Uint8List.fromList([
    0,
    -92,
    4,
    0,
    8,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    -77,
    0,
    0,
    63,
    0,
    -75,
    0,
    0,
    10,
    0,
    -78,
    0,
    0,
    40
  ]);
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
  EmoneyCardInfo(super.commandApi);
  @override
  requestData() async {
    Uint8List cardNumCommand = _commandDatas.sublist(13, 18);
    CommandResponse response = await _commandApi!.sendCommand(cardNumCommand);
    if (response.isSuccess) {
      cardNum = NfcUtil.getCardNum(response.data!, 8);
      Uint8List amountCommand = _commandDatas.sublist(18, 23);
      CommandResponse response2 = await _commandApi.sendCommand(amountCommand);
      if (response2.isSuccess) {
        Uint8List transceive2 = response2.data!;
        int tempAmount = 0;
        for (int i = 0; i < 4; i++) {
          tempAmount += (transceive2[i] & 0xFF) << (i * 8);
        }
        amount = tempAmount;
      }
    }
  }

  @override
  String get brand => 'Emoney';

  @override
  String get logo => 'logo_emoney';

  @override
  String get name => 'Mandiri e-money';

  @override
  Color get color => const Color(0xFFf56823);
}

class FlazzCardInfo extends BaseCardInfo {
  FlazzCardInfo(super.commandApi);
  @override
  requestData() async {
    Uint8List bArr = Uint8List.fromList([
      0,
      -92,
      4,
      0,
      11,
      -96,
      0,
      0,
      0,
      24,
      15,
      0,
      0,
      1,
      -128,
      1,
      0,
      -92,
      1,
      0,
      2,
      2,
      0,
      0,
      -80,
      -127,
      0,
      -114
    ]);
    Uint8List bArr2 = Uint8List.fromList(
        [-128, 50, 0, 3, 4, 0, 0, 0, 0, 0, -80, -124, 0, 60]);
    Uint8List copyOfRange = bArr.sublist(16, 23);
    Uint8List copyOfRange2 = bArr.sublist(23, 28);
    CommandResponse response = await _commandApi!.sendCommand(copyOfRange);

    if (response.isSuccess) {
      CommandResponse response2 = await _commandApi.sendCommand(copyOfRange2);
      if (response2.isSuccess) {
        cardNum = String.fromCharCodes(response2.data!.sublist(104, 120));
        CommandResponse response3 =
            await _commandApi.sendCommand(bArr2.sublist(0, 9));
        if (response3.isSuccess) {
          var amountList = response3.data!.sublist(0, 4);
          amount = NfcUtil.getAmount2(amountList);
        }
      }
    }
  }

  @override
  String get name => 'BCA FLAZZ';

  @override
  String get brand => 'Flazz';

  @override
  Color get color => const Color(0xFF0061bc);

  @override
  String get logo => 'logo_flazz';
}

class BrizziCardInfo extends BaseCardInfo {
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
  BrizziCardInfo(super.commandApi);
  @override
  requestData() async {
    Uint8List copyOfRange3 = Uint8List.fromList(brizziBytes.sublist(9, 22));
    Uint8List copyOfRange4 = Uint8List.fromList(brizziBytes.sublist(22, 29));
    print('========bArr request cardNum,copyOfRange3:$copyOfRange3');
    CommandResponse response = await _commandApi!.sendCommand(copyOfRange3);

    if (response.isSuccess) {
      var bArr8 = response.data!;
      if (bArr8.length >= 12) {
        print('========bArr8:$bArr8');
        cardNum = NfcUtil.getCardNum(bArr8.sublist(3, 12), 8);
      }

      print('========bArr request amount,copyOfRange4:$copyOfRange4');
      CommandResponse response2 = await _commandApi.sendCommand(copyOfRange4);

      if (response2.isSuccess) {
        var bArr9 = response2.data!;
        print('========bArr9:$bArr9');

        int j = 0;
        if (bArr9.length >= 2) {
          for (int i = 0; i < 2; i++) {
            j += (bArr9[i] & 255) << (i * 8);
          }
        }
        amount = j;
      } else {
        amount = 0;
      }
    }
  }

  @override
  String get brand => 'Brizzi';

  @override
  Color get color => const Color(0xFF1f4396);

  @override
  String get logo => 'logo_brizzi';

  @override
  String get name => 'BRI BRIZZI';
}

class TapCashCardInfo extends BaseCardInfo {
  TapCashCardInfo(super.commandApi);
  @override
  requestData() async {
    Uint8List bArr = Uint8List.fromList([
      0,
      -92,
      4,
      0,
      8,
      -96,
      0,
      66,
      78,
      73,
      16,
      0,
      1,
      -112,
      50,
      3,
      0,
      0,
      -112,
      50,
      3,
      0,
      1
    ]);

    CommandResponse response =
        await _commandApi!.sendCommand(bArr.sublist(13, 18));
    if (response.isSuccess) {
      var bArr3 = response.data!;
      Uint8List copyOfRange3 = bArr3.sublist(3, 5);
      Uint8List copyOfRange4 = bArr3.sublist(8, 16);
      amount = NfcUtil.getAmount2(copyOfRange3);
      cardNum = NfcUtil.getCardNum(copyOfRange4, 8);
    }
  }

  @override
  String get brand => 'TapCash';

  @override
  Color get color => const Color(0xFFea7528);

  @override
  String get logo => 'logo_tapcash';

  @override
  String get name => 'TAP CASH';
}

class JackCardInfo extends BaseCardInfo {
  JackCardInfo(super.commandApi);
  @override
  requestData() async {
    Uint8List bArr = Uint8List.fromList(
        [0, -92, 4, 0, 8, -96, 0, 0, 5, 113, 78, 74, 67, -112, 76, 0, 0, 4]);
    CommandResponse response =
        await _commandApi!.sendCommand(bArr.sublist(0, 13));
    if (response.isSuccess) {
      var bArr2 = response.data!;
      cardNum = NfcUtil.getCardNum(bArr2.sublist(8, 16), 8);
      CommandResponse response2 =
          await _commandApi.sendCommand(bArr.sublist(13, 18));
      Uint8List copyOfRange5 = response2.data!.sublist(0, 4);
      amount = NfcUtil.getAmount2(copyOfRange5);
    }
  }

  @override
  String get brand => 'JakLingKo';

  @override
  Color get color => const Color(0xFF00609d);

  @override
  String get logo => 'logo_jaklinko';

  @override
  String get name => 'JAK LING KO';
}

class OtherCardInfo extends BaseCardInfo {
  OtherCardInfo(super.commandApi);

  @override
  String get brand => 'Other';

  @override
  Color get color => const Color(0xFF00609d);

  @override
  String get logo => '';

  @override
  String get name => '杂牌';

  @override
  requestData() {
    cardNum = '0000000000000000';
    amount = 0;
  }
}
