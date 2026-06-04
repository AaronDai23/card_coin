import 'dart:io';
import 'dart:typed_data';

import 'package:card_coin/utils/hex_utils.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../http/address.dart';
import '../http/http_manager.dart';
import '../utils/aes_util.dart';
import '../utils/string_util.dart';

class CommandResponse {
  Uint8List? data;
  late bool isSuccess;
  late String appleVersionCode;
  String? message;
  late int sw1;
  late int sw2;

  CommandResponse(this.sw1, this.sw2, this.isSuccess,
      {this.data, this.message});

  CommandResponse.fromData(Uint8List response) {
    print('response data33:$response');
    sw1 = response[response.length - 2];
    sw2 = response[response.length - 1];
    isSuccess = sw1 == 0x90 && sw2 == 0;
    print('response isSuccess3334444:$isSuccess');
    data = response.sublist(0, response.length - 2);

    if (!isSuccess) {
      message = _getErrorMsg(sw1, sw2);
    }
  }

  CommandResponse.fromIosData(Iso7816ResponseApdu apdu) {
    print('response data55:$apdu');
    sw1 = apdu.statusWord1;
    sw2 = apdu.statusWord2;
    isSuccess = sw1 == 0x90 && sw2 == 0;
    print('response isSucces555555:$isSuccess');
    data = apdu.payload;
    if (!isSuccess) {
      message = _getErrorMsg(sw1, sw2);
    }
  }

  CommandResponse copyWith(Uint8List? data) {
    return CommandResponse(sw1, sw2, isSuccess,
        data: data ?? this.data, message: message);
  }

  String _getErrorMsg(int b1, int b2) {
    if (b1 == 0xAA && b2 == 0x00) {
      return 'Command not allowed';
    } else if (b1 == 0xAA && b2 == 0x02) {
      return 'P1 and/or P2 incorrect';
    } else if (b1 == 0xAA && b2 == 0x03) {
      return 'Wrong length';
    } else if (b1 == 0xAA && b2 == 0x10) {
      return 'UID length error';
    } else if (b1 == 0xAA && b2 == 0x11) {
      return 'UID validate failed';
    } else if (b1 == 0xAA && b2 == 0x12) {
      return 'UID data failed';
    } else if (b1 == 0xAA && b2 == 0x20) {
      return 'Data invalid';
    } else if (b1 == 0xAA && b2 == 0x21) {
      return 'Error code thrown if entered PIN was incorrect';
    } else if (b1 == 0xAA && b2 == 0x22) {
      return 'PIN required';
    } else if (b1 == 0xAA && b2 == 0x23) {
      return 'Card is locked';
    } else if (b1 == 0xAA && b2 == 0x24) {
      return 'Error code thrown if entered PUK was incorrect';
    } else if (b1 == 0xAA && b2 == 0x25) {
      return 'The card has expired,over the maximum number of failed PUK';
    } else if (b1 == 0xAA && b2 == 0x30) {
      return 'ECC Key pair not exist';
    } else if (b1 == 0xAA && b2 == 0x31) {
      return 'ECC Key pair exist';
    } else if (b1 == 0xAB && b2 == 0x12) {
      return 'PUK TAG ERROR';
    } else {
      return 'Unknown error';
    }
  }
}

class IsoCommandUtils {}

abstract class CommandApi {
  Future<CommandResponse> sendCommand(Uint8List header,
      {Uint8List? data, bool encrypt = true});
}

class Iso7816CommandApi implements CommandApi {
  late Iso7816 iso7816;
  Uint8List? aesKey;

  ///默认appletId
  final List<int> _defaultAppletId = [
    0x68,
    0x64,
    0x69,
    0x6E,
    0x73,
    0x74,
    0x61,
    0x63,
    0x61,
    0x73,
    0x68,
    0x00
  ];

  ///选择applet的命令头
  final List<int> _selectHeader = [0x00, 0xA4, 0x04, 0x00];

  ///applet id
  List<int>? aid;

  // Iso7816CommandApi(Iso7816 iso7816) {
  //   _iso7816 = iso7816;
  // }

  @override
  Future<CommandResponse> sendCommand(Uint8List header,
      {List<int>? data, bool encrypt = true}) async {
    List<int> appletId = aid ?? _defaultAppletId;
    Uint8List selectCmd =
        Uint8List.fromList([..._selectHeader, appletId.length, ...appletId]);
    Iso7816ResponseApdu apdu = await iso7816.sendCommandRaw(selectCmd);
    final selectResponse = CommandResponse.fromIosData(apdu);
    if (selectResponse.isSuccess) {
      aesKey = selectResponse.data;

      Uint8List commandData;
      if (data != null) {
        if (encrypt) {
          Uint8List bytes = _encryptData(Uint8List.fromList(data));
          commandData = Uint8List.fromList([...header, bytes.length, ...bytes]);
        } else {
          commandData = Uint8List.fromList([...header, data.length, ...data]);
        }
      } else {
        commandData = Uint8List.fromList(header);
      }

      Iso7816ResponseApdu apdu1 = await iso7816.sendCommandRaw(commandData);
      // 创建一个足够大的新Uint8List来存储结果
      Uint8List foot =
          Uint8List.fromList([apdu1.statusWord1, apdu1.statusWord2]);
      Uint8List combinedList = Uint8List(apdu1.payload.length + foot.length);

      // 将list1复制到combinedList
      combinedList.setAll(0, apdu1.payload);

      // 将list2复制到combinedList的末尾
      combinedList.setAll(apdu1.payload.length, foot);

      ///上传Log
      _updateLog(iso7816.identifier, commandData, combinedList);

      final commandResponse = CommandResponse.fromData(combinedList);
      if (commandResponse.isSuccess) {
        final decryptData = encrypt
            ? _decryptData(commandResponse.data!)
            : commandResponse.data;

        ///上传Log
        // _updateLog(isoDep.identifier, data, decryptData);
        return commandResponse.copyWith(decryptData);
      } else {
        //  final decryptData = _decryptData(commandResponse.data!);
        // _updateLog(isoDep.identifier, data, decryptData);

        return commandResponse;
      }
    } else {
      return selectResponse;
    }
  }

  Uint8List intToUint8List(int value) {
    final Uint8List list = Uint8List(4);
    for (int i = 0; i < 4; i++) {
      list[i] = (value >> (i * 8)) & 0xFF;
    }
    return list;
  }

  void _updateLog(Uint8List uid, Uint8List requestData, Uint8List response) {
    final data = <String, dynamic>{
      "apduRequest": StringUtils.uint8ToHex(requestData),
      "apduResponse": StringUtils.uint8ToHex(response),
      "uid": StringUtils.uint8ToHex(uid)
    };
    HttpManager.getInstance()
        .post(NetworkAddress.apduLogUrl, null, data: data)
        .then((value) {
      print('upload log result:$value');
    });
  }

  Uint8List _encryptData(Uint8List data) {
    if (data.length < 5) {
      return data;
    }
    Uint8List encryptData;
    List<int> key = [...aesKey ?? [], ...iso7816.identifier.take(4)];
    // List<int> key = [0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,..._isoDep.identifier];
    final temp = data.length % 16;
    if (temp != 0) {
      encryptData = Uint8List.fromList(
          [...data, ...List.generate(16 - temp, (index) => 0)]);
    } else {
      encryptData = data;
    }

    return AesUtil.encryptData(key, encryptData);
  }

  Uint8List _decryptData(Uint8List data) {
    List<int> key = [...aesKey ?? [], ...iso7816.identifier.take(4)];
    // List<int> key = [0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,..._isoDep.identifier];

    return Uint8List.fromList(AesUtil.decryptData(key, data));
  }

  Iso7816CommandApi(Iso7816 iso78161, {List<int>? aid1}) {
    iso7816 = iso78161;
    aid = aid1;
  }
}

class IsoDepCommandApi implements CommandApi {
  Uint8List? aesKey;
  late IsoDep isoDep;

  ///默认appletId
  final List<int> _defaultAppletId = [
    0x68,
    0x64,
    0x69,
    0x6E,
    0x73,
    0x74,
    0x61,
    0x63,
    0x61,
    0x73,
    0x68,
    0x00
  ];

  ///选择applet的命令头
  final List<int> _selectHeader = [0x00, 0xA4, 0x04, 0x00];

  ///applet id
  List<int>? aid;

  @override
  Future<CommandResponse> sendCommand(Uint8List header,
      {List<int>? data, bool encrypt = true}) async {
    List<int> appletId = aid ?? _defaultAppletId;
    Uint8List selectCmd =
        Uint8List.fromList([..._selectHeader, appletId.length, ...appletId]);
    Uint8List selectResponseData = await isoDep.transceive(data: selectCmd);
    final selectResponse = CommandResponse.fromData(selectResponseData);
    print('IsoDepCommandApi-selectResponse:${selectResponse.isSuccess}');
    if (selectResponse.isSuccess) {
      aesKey = selectResponse.data;
      // print('IsoDepCommandApi-aesKey:${hex.encode(aesKey!)}');

      Uint8List commandData;
      if (data != null) {
        if (encrypt) {
          Uint8List bytes = _encryptData(Uint8List.fromList(data));
          commandData = Uint8List.fromList([...header, bytes.length, ...bytes]);
        } else {
          commandData = Uint8List.fromList([...header, data.length, ...data]);
        }
      } else {
        commandData = Uint8List.fromList(header);
      }
      Uint8List response = await isoDep.transceive(data: commandData);

      ///上传Log
      _updateLog(isoDep.identifier, commandData, response);

      final commandResponse = CommandResponse.fromData(response);
      if (commandResponse.isSuccess) {
        final decryptData = encrypt
            ? _decryptData(commandResponse.data!)
            : commandResponse.data;

        ///上传Log
        // _updateLog(isoDep.identifier, data, decryptData);
        return commandResponse.copyWith(decryptData);
      } else {
        //  final decryptData = _decryptData(commandResponse.data!);
        // _updateLog(isoDep.identifier, data, decryptData);

        return commandResponse;
      }
    } else {
      return selectResponse;
    }
  }

  void _updateLog(Uint8List uid, Uint8List requestData, Uint8List response) {
    final data = <String, dynamic>{
      "apduRequest": StringUtils.uint8ToHex(requestData),
      "apduResponse": StringUtils.uint8ToHex(response),
      "uid": StringUtils.uint8ToHex(uid)
    };
    HttpManager.getInstance()
        .post(NetworkAddress.apduLogUrl, null, data: data)
        .then((value) {
      print('upload log result:$value');
    });
  }

  Uint8List _encryptData(Uint8List data) {
    if (data.length < 5) {
      return data;
    }
    Uint8List encryptData;
    List<int> key = [...aesKey ?? [], ...isoDep.identifier.take(4)];
    // List<int> key = [0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,..._isoDep.identifier];
    final temp = data.length % 16;
    if (temp != 0) {
      encryptData = Uint8List.fromList(
          [...data, ...List.generate(16 - temp, (index) => 0)]);
    } else {
      encryptData = data;
    }

    return AesUtil.encryptData(key, encryptData);
  }

  Uint8List _decryptData(Uint8List data) {
    List<int> key = [...aesKey ?? [], ...isoDep.identifier.take(4)];
    // List<int> key = [0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,..._isoDep.identifier];

    return Uint8List.fromList(AesUtil.decryptData(key, data));
  }

  IsoDepCommandApi(this.isoDep, {this.aid});
}

class IsoDepReaderManager {
  late IsoDep _isoDep;
  late Iso7816 _iso7816Dep;
  Uint8List? aesKey;
  late IsoDepCommandApi _commandApi;
  late Iso7816CommandApi _iso7816commandApi;

  List<int> get encryptKey {
    if (Platform.isAndroid) {
      if (_commandApi.aesKey == null) {
        throw Exception('aesKey is empty');
      }
      return [..._commandApi.aesKey ?? [], ..._isoDep.identifier.take(4)];
    } else {
      if (_iso7816commandApi.aesKey == null) {
        throw Exception('aesKey is empty');
      }
      return [..._iso7816commandApi.aesKey ?? [], ..._iso7816Dep.identifier];
    }
  }

  IsoDepReaderManager(IsoDep? isoDep,
      {List<int>? appletId, Iso7816? ios7816Dep}) {
    if (Platform.isAndroid) {
      _isoDep = isoDep!;
      _commandApi = IsoDepCommandApi(_isoDep, aid: appletId);
    } else {
      _iso7816Dep = ios7816Dep!;
      _iso7816commandApi = Iso7816CommandApi(_iso7816Dep, aid1: appletId);
      print("_iso7816commandApi:$_iso7816commandApi");
    }
  }

  String get cardId => HexUtils.uint8ListToHex(
      Platform.isAndroid ? _isoDep.identifier : _iso7816Dep.identifier);

  Future<CommandResponse> sendCommand(Uint8List header,
      {List<int>? data, bool encrypt = true}) {
    return Platform.isAndroid
        ? _commandApi.sendCommand(header, data: data, encrypt: encrypt)
        : _iso7816commandApi.sendCommand(header, data: data, encrypt: encrypt);
  }

  ///查询PIN设置状态
  Future<CommandResponse> queryPinCodeStatus() async {
    ///查询是否设置PIN
    var tempData = Uint8List.fromList([0x80, 0x54, 0x00, 0x00]);

    ///查询固定的测试密钥
    // var tempData = Uint8List.fromList([0x80,0x99,0x00,0x00]);

    ///是否开启加密通道
    // var tempData = Uint8List.fromList([0x80, 0x9B, 0x00, 0x00,0x01,0x01]);

    // _testEncryptData();
    // [0xa0,0xa1,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,0xa8,0xa9,0xaa,0xab,0x27,0xc7,0x0a,0xd7];

    return Platform.isAndroid
        ? await _commandApi.sendCommand(tempData)
        : await _iso7816commandApi.sendCommand(tempData);

    // return await isoDepCommandApi.sendCommand(encryptData);
  }

  ///创建PIN码
  Future<CommandResponse> createPinCode(Uint8List pinCode) async {
    var header = Uint8List.fromList([0x80, 0x50, 0x00, 0x00]);
    // print('all data hex:${HexUtils.uint8ListToHex(data)}');
    return Platform.isAndroid
        ? await _commandApi
            .sendCommand(header, data: [0x95, pinCode.length, ...pinCode])
        : await _iso7816commandApi
            .sendCommand(header, data: [0x95, pinCode.length, ...pinCode]);
  }

  ///更新PIN码
  Future<CommandResponse> updatePinCode(
      List<int> pinCode, List<int> newPinCode) async {
    var header = Uint8List.fromList([0x80, 0x51, 0x00, 0x00]);

    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [
            0x95,
            pinCode.length,
            ...pinCode,
            0x95,
            newPinCode.length,
            ...newPinCode
          ])
        : await _iso7816commandApi.sendCommand(header, data: [
            0x95,
            pinCode.length,
            ...pinCode,
            0x95,
            newPinCode.length,
            ...newPinCode
          ]);
  }

  ///取消PIN码
  Future<CommandResponse> cancelPinCode(
      List<int> pukCode, List<int> pinCode) async {
    var header = Uint8List.fromList([0x80, 0x57, 0x00, 0x00]);

    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [
            0x96,
            pukCode.length,
            ...pukCode,
            0x95,
            pinCode.length,
            ...pinCode
          ])
        : await _iso7816commandApi.sendCommand(header, data: [
            0x96,
            pukCode.length,
            ...pukCode,
            0x95,
            pinCode.length,
            ...pinCode
          ]);
  }

  ///解锁PIN码
  Future<CommandResponse> unlockCard(
      List<int> pukCode, List<int> pinCode) async {
    var header = Uint8List.fromList([0x80, 0x52, 0x00, 0x00]);

    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [
            0x96,
            pukCode.length,
            ...pukCode,
            0x95,
            pinCode.length,
            ...pinCode
          ])
        : await _iso7816commandApi.sendCommand(header, data: [
            0x96,
            pukCode.length,
            ...pukCode,
            0x95,
            pinCode.length,
            ...pinCode
          ]);
  }

  ///查询PIN码可偿试次数
  Future<CommandResponse> queryPinCodeCount() async {
    var data = Uint8List.fromList([0x80, 0x55, 0x00, 0x00]);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data)
        : await _iso7816commandApi.sendCommand(data);
  }

  ///查询PUK码可偿试次数
  Future<CommandResponse> queryPukCodeCount() async {
    var data = Uint8List.fromList([0x80, 0x56, 0x00, 0x00]);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data)
        : await _iso7816commandApi.sendCommand(data);
  }

  /// 重置设备
  Future<CommandResponse> resetDevice({List<int>? pinCode}) async {
    String timeStr = DateTime.now().millisecondsSinceEpoch.toString();
    List<int> list = timeStr.codeUnits;
    Uint8List header = Uint8List.fromList([0x80, 0x44, 0x00, 0x00]);

    List<int> data = [0x97, 0x0D, ...list];
    if (pinCode != null) {
      print('all data pinCode:$pinCode');
      data.addAll([0x95, pinCode.length, ...pinCode]);
    }

    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: data)
        : await _iso7816commandApi.sendCommand(header, data: data);
  }

  /// 钱包导出
  Future<CommandResponse> exportCardData(List<int> pinCode) async {
    Uint8List header = Uint8List.fromList([0x80, 0x45, 0x00, 0x00]);
    return Platform.isAndroid
        ? await _commandApi
            .sendCommand(header, data: [0x95, pinCode.length, ...pinCode])
        : await _iso7816commandApi
            .sendCommand(header, data: [0x95, pinCode.length, ...pinCode]);
  }

  /// 钱包导出
  Future<CommandResponse> importCardData(
      List<int> pinCode, String cardData) async {
    Uint8List cardCode = HexUtils.hexStringToUint8List(cardData);
    Uint8List header = Uint8List.fromList([0x80, 0x46, 0x00, 0x00]);
    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [
            0x91,
            cardCode.length,
            ...cardCode,
            0x95,
            pinCode.length,
            ...pinCode
          ])
        : await _iso7816commandApi.sendCommand(header, data: [
            0x91,
            cardCode.length,
            ...cardCode,
            0x95,
            pinCode.length,
            ...pinCode
          ]);
  }

  /// 读取设备版本
  Future<CommandResponse> readDeviceVersionData() async {
    Uint8List data = _getVersionHex();
    return Platform.isAndroid
        ? await _commandApi.sendCommand(data)
        : await _iso7816commandApi.sendCommand(data);
  }

  Uint8List _getVersionHex() {
    List<int> data = [0x80, 0x30, 0x00, 0x00];
    return Uint8List.fromList(data);
  }

  Future<CommandResponse> secureChannelSetting(bool isOpen) async {
    Uint8List header = Uint8List.fromList([0x80, 0x9B, 0x00, 0x00]);

    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [isOpen ? 0x01 : 0x00])
        : await _iso7816commandApi
            .sendCommand(header, data: [isOpen ? 0x01 : 0x00]);
  }

  Future<CommandResponse> encryptData(String content) async {
    List<int> data = [0x80, 0x9C, 0x00, 0x00];
    return Platform.isAndroid
        ? await _commandApi.sendCommand(Uint8List.fromList(data),
            data: content.codeUnits, encrypt: false)
        : await _iso7816commandApi.sendCommand(Uint8List.fromList(data),
            data: content.codeUnits, encrypt: false);
  }

  Future<CommandResponse> decryptData(Uint8List content) async {
    List<int> data = [0x80, 0x9D, 0x00, 0x00];
    return Platform.isAndroid
        ? await _commandApi.sendCommand(Uint8List.fromList(data),
            data: [...content], encrypt: false)
        : await _iso7816commandApi.sendCommand(Uint8List.fromList(data),
            data: [...content], encrypt: false);
  }

  ///tore NDEF Data
  Future<CommandResponse> storeNDEFData(List<int> ndef) async {
    List<int> data = [0x80, 0x63, 0x00, 0x00];
    Uint8List sendData = Uint8List.fromList(data);
    print('storeNDEFData hex:$sendData');
    return Platform.isAndroid
        ? await _commandApi
            .sendCommand(sendData, data: [0x9B, ndef.length, ...ndef])
        : await _iso7816commandApi
            .sendCommand(sendData, data: [0x9B, ndef.length, ...ndef]);
  }

  Future<CommandResponse> getPrivateKey() async {
    var data = Uint8List.fromList([0x80, 0x82, 0x00, 0x00]);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data, encrypt: false)
        : await _iso7816commandApi.sendCommand(data, encrypt: false);
  }

  Future<CommandResponse> getPublicKey() async {
    var data = Uint8List.fromList([0x80, 0x81, 0x00, 0x00]);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data, encrypt: false)
        : await _iso7816commandApi.sendCommand(data, encrypt: false);
  }

  Future<CommandResponse> getDerivePrivateKey(Uint8List derivePath) async {
    var header = [0x80, 0x84, 0x00, 0x00];

    return Platform.isAndroid
        ? await _commandApi.sendCommand(Uint8List.fromList(header),
            data: [0x94, derivePath.length, ...derivePath], encrypt: false)
        : await _iso7816commandApi.sendCommand(Uint8List.fromList(header),
            data: [0x94, derivePath.length, ...derivePath], encrypt: false);
  }

  ///汇总状态查询
  Future<CommandResponse> queryCardStatus() async {
    var data = Uint8List.fromList([0x80, 0x31, 0x00, 0x00]);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data)
        : await _iso7816commandApi.sendCommand(data);
  }

  //  Get Derive Info
  Future<CommandResponse> getDeriveInfo() async {
    //
    var arr = [
      0x80,
      0x42,
      0x00,
      0x00,
    ];

    var header = Uint8List.fromList(arr);
    print('all data hex:${HexUtils.uint8ListToHex(header)}');
    return Platform.isAndroid
        ? await _commandApi.sendCommand(header, data: [
            0x94,
            0x14,
            0x80,
            0x00,
            0x00,
            0x2C,
            0x80,
            0x00,
            0x00,
            0x00,
            0x80,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x05
          ])
        : await _iso7816commandApi.sendCommand(header, data: [
            0x94,
            0x14,
            0x80,
            0x00,
            0x00,
            0x2C,
            0x80,
            0x00,
            0x00,
            0x00,
            0x80,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x05
          ]);
  }

  //  Get Derive Info
  Future<CommandResponse> signature() async {
    //
    var arr = [
      0x80,
      0x32,
      0x00,
      0x00,
    ];

    var data = Uint8List.fromList(arr);
    print('all data hex:${HexUtils.uint8ListToHex(data)}');

    return Platform.isAndroid
        ? await _commandApi.sendCommand(data, data: [
            0x93,
            0x20,
            0xBB,
            0xDC,
            0xF1,
            0x71,
            0x91,
            0x97,
            0xE1,
            0xEE,
            0x77,
            0x73,
            0x67,
            0x05,
            0x20,
            0x9A,
            0x64,
            0x53,
            0xB6,
            0x2C,
            0x89,
            0x21,
            0xCB,
            0xAF,
            0x7D,
            0xA4,
            0x1B,
            0xC2,
            0xE5,
            0x2E,
            0x0B,
            0x07,
            0x60,
            0xA1,
            0x94,
            0x14,
            0x80,
            0x00,
            0x00,
            0x2C,
            0x80,
            0x00,
            0x00,
            0x00,
            0x80,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x05
          ])
        : await _iso7816commandApi.sendCommand(data, data: [
            0x93,
            0x20,
            0xBB,
            0xDC,
            0xF1,
            0x71,
            0x91,
            0x97,
            0xE1,
            0xEE,
            0x77,
            0x73,
            0x67,
            0x05,
            0x20,
            0x9A,
            0x64,
            0x53,
            0xB6,
            0x2C,
            0x89,
            0x21,
            0xCB,
            0xAF,
            0x7D,
            0xA4,
            0x1B,
            0xC2,
            0xE5,
            0x2E,
            0x0B,
            0x07,
            0x60,
            0xA1,
            0x94,
            0x14,
            0x80,
            0x00,
            0x00,
            0x2C,
            0x80,
            0x00,
            0x00,
            0x00,
            0x80,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x05
          ]);
  }

  ///get NDEF Data
  Future<CommandResponse> getNDEFData() async {
    List<int> data = [0x80, 0x62, 0x00, 0x00];
    Uint8List sendData = Uint8List.fromList(data);
    print('getNDEFData hex:$sendData');
    return Platform.isAndroid
        ? await _commandApi.sendCommand(sendData)
        : await _iso7816commandApi.sendCommand(sendData);
  }

  Future<CommandResponse> shareVersion() async {
    List<int> data = [0x80, 0x30, 0x00, 0x00];
    Uint8List sendData = Uint8List.fromList(data);
    print('shareVersion hex:$sendData');
    return Platform.isAndroid
        ? await _commandApi.sendCommand(sendData, encrypt: false)
        : await _iso7816commandApi.sendCommand(sendData, encrypt: false);
  }

  Future<CommandResponse> ndedfVersion() async {
    List<int> data = [0x80, 0x30, 0x00, 0x00];
    Uint8List sendData = Uint8List.fromList(data);
    print('ndedfVersion hex:$sendData');
    return Platform.isAndroid
        ? await _commandApi.sendCommand(sendData, encrypt: false)
        : await _iso7816commandApi.sendCommand(sendData, encrypt: false);
  }
}
