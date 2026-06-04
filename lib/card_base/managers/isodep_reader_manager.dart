import 'dart:typed_data';


import 'package:card_coin/card_base/bean/card_info_bean.dart';
import 'package:common_utils/common_utils.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../utils/nfc_util.dart';

//                                   0,-92,4,0,8,0,0,0,0,0,0,0,1
//                                   0,   -92,   4,    0,    8,    0,    0,    0,    0,    0,    0,    0,    1
const List<int> appServiceList =  [0x00, 0xA4, 0x04, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01];
//                                   0,  -92,   4,    0,    11,  -96,   0,    0,    0,    24,   15,   0,    0,    1,    0,     1
const List<int> appServiceList1 = [0x00, 0xA4, 0x04, 0x00, 0x0B, 0xA0, 0x00, 0x00, 0x00, 0x18, 0x0F, 0x00, 0x00, 0x01, 0x00, 0x01];
//                                 -112,  90,   0,    0,    3,    1,    0,    0,    0
const List<int> appServiceList2 = [0x90, 0x5A, 0x00, 0x00,0x03, 0x01, 0x00, 0x00, 0x00];
//                                  0,   -92,   4,    0,    8,   -96,   0,   66,   78,   73,   16,   0,     1
const List<int> appServiceList3 = [0x00, 0xA4, 0x04, 0x00,0x08, 0xA0, 0x00, 0x42, 0x4E, 0x49, 0x10, 0x00, 0x01];
//                                  0,   -92,   4,    0,    8,   -96,   0,   0,    5,   113,   78,   74,   67
const List<int> appServiceList4 = [0x00, 0xA4, 0x04, 0x00,0x08, 0xA0, 0x00, 0x00, 0x05, 0x71, 0x4E, 0x4A, 0x43];
//                                 -112,  90,   0,    0,    3,    0,  -120,   0,    0
const List<int> appServiceList5 = [0x90, 0x5A, 0x00, 0x00,0x03, 0x00, 0x88, 0x00, 0x00];
//                                  0,   -92,   0,    0,    2,    0,   10
const List<int> appServiceList6 = [0x00, 0xA4, 0x00, 0x00,0x02, 0x00, 0x0A];

//                                   0,   -92,   4,    0,    7,   -45,  96,   0,     0,   3,   0,    3
const List<int> appServiceList10 = [0x00, 0xA4, 0x04, 0x00,0x07, 0xD3, 0x60, 0x00, 0x00,0x03, 0x00, 0x03];

const List<int> servicebytes2 = [0, -92, 4, 0, 8, -96, 0, 66, 78, 73, 16, 0, 1, -112, 50, 3, 0, 0, -112, 50, 3, 0, 1];
const List<int> servicebytes3 = [0, -92, 4, 0, 8, -96, 0, 0, 5, 113, 78, 74, 67, -112, 76, 0, 0, 4];



const List<int> cardNumList = [0x00, 0xB3, 0x00, 0x00, 0x3F];
const List<int> amountList = [0x00, 0xB5, 0x00, 0x00, 0x0A];

class CommandResponse{
  Uint8List? data;
  bool isSuccess;
  CommandResponse(this.isSuccess,this.data);
}

// class Iso7816CommandResponse extends BaseCommandResponse{
//   bool isSuccess;
//   Iso7816CommandResponse(this.isSuccess, {Uint8List? data}) : super(data);
// }

abstract class CommandApi{
  Future<CommandResponse> sendCommand(Uint8List data);
}

class AndroidIso7816CommandApi implements CommandApi{
  late IsoDep _isoDep;

  AndroidIso7816CommandApi(IsoDep isoDep){
    _isoDep = isoDep;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Uint8List response = await _isoDep.transceive(data: data);
    var isSuccess = NfcUtil.verifySuccess(response);
    return CommandResponse(isSuccess, response);
  }
}

class Iso7816CommandApi implements CommandApi{
  late Iso7816 _iso7816;

  Iso7816CommandApi(Iso7816 iso7816){
    _iso7816 = iso7816;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Iso7816ResponseApdu apdu = await _iso7816.sendCommandRaw(data);
    return CommandResponse(apdu.statusWord1 == 0x90 && apdu.statusWord2 == 0, apdu.payload);
  }
}

class Iso7816BrizziCommandApi implements CommandApi{
  late Iso7816 _iso7816;

  Iso7816BrizziCommandApi(Iso7816 iso7816){
    _iso7816 = iso7816;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Iso7816ResponseApdu apdu = await _iso7816.sendCommandRaw(data);

    print('apdu.statusWord1:${apdu.statusWord1},apdu.statusWord2:${apdu.statusWord2},payload:${apdu.payload}');
    return CommandResponse(apdu.statusWord1 == 0x91 && apdu.statusWord2 == 0, apdu.payload);
  }
}

class FareIso7816CommandApi implements CommandApi{
  late MiFare _miFare;

  FareIso7816CommandApi(MiFare miFare){
    _miFare = miFare;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Iso7816ResponseApdu apdu = await _miFare.sendMiFareIso7816CommandRaw(data);
    print('apdu.statusWord1:${apdu.statusWord1},apdu.statusWord2:${apdu.statusWord2},payload:${apdu.payload}');
    return CommandResponse(apdu.statusWord1 == 0x91 && apdu.statusWord2 == 0, apdu.payload);
  }
}

class AndroidBrizziCommandApi implements CommandApi{
  late IsoDep _isoDep;

  AndroidBrizziCommandApi(IsoDep isoDep){
    _isoDep = isoDep;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Uint8List response = await _isoDep.transceive(data: data);
    var isSuccess = NfcUtil.brizziVerifySuccess(response);
    return CommandResponse(isSuccess, response);
  }
}

class AndroidJackCommandApi implements CommandApi{
  late IsoDep _isoDep;

  AndroidJackCommandApi(IsoDep isoDep){
    _isoDep = isoDep;
  }

  @override
  Future<CommandResponse> sendCommand(Uint8List data) async {
    Uint8List response = await _isoDep.transceive(data: data);
    var isSuccess = NfcUtil.jackVerifySuccess(response);
    return CommandResponse(isSuccess, response);
  }
}


// class IsoDepCommandApi implements CommandApi{
//   late IsoDep _isoDep;
//   IsoDepCommandApi(IsoDep isoDep){
//     _isoDep = isoDep;
//   }
//
//   @override
//   Future<Uint8List> sendCommand(Uint8List data) async {
//     Uint8List resultData = await _isoDep.transceive(data: data);
//     return resultData;
//   }
// }

// class ReaderManager{
//   late CommandApi _commandApi;
//   ReaderManager(CommandApi commandApi){
//     _commandApi = commandApi;
//   }
//
//   Future<BaseCardInfo?> getCardInfo() async {
//
//     Uint8List response = await _commandApi.sendCommand(Uint8List.fromList(emoneyBytes.sublist(0,13)));
//
//     return response;
//   }
//
// }


class IsoDepReaderManager {
  late IsoDep _isoDep;

  IsoDepReaderManager(IsoDep isoDep) {
    _isoDep = isoDep;
  }


  Future<BaseCardInfo?> getCardInfo() async {

    Exception? errorException;

    BaseCardInfo? cardInfo;

    try{
      var commandApi = AndroidIso7816CommandApi(_isoDep);
      CommandResponse emoneyResponse = await commandApi.sendCommand(Uint8List.fromList(emoneyBytes.sublist(0,13)));
      if(emoneyResponse.isSuccess){
        cardInfo = EmoneyCardInfo(commandApi);
      }

    }catch(error){
      errorException = Exception(error.toString());
      LogUtil.d( "emoney connect error :$error");
    }

    if(cardInfo == null){
      try{
        var commandApi = AndroidIso7816CommandApi(_isoDep);
        CommandResponse flazzResponse = await commandApi.sendCommand(Uint8List.fromList(flazzBytes.sublist(0,16)));
        if(flazzResponse.isSuccess){
          cardInfo = FlazzCardInfo(commandApi);
        }
      }catch(error){
        errorException = Exception(error.toString());
        LogUtil.d( "flazz result connect to flash error :$error");
      }
    }


    if(cardInfo == null){
      try{
        var commandApi = AndroidBrizziCommandApi(_isoDep);
        CommandResponse brizziResponse = await commandApi.sendCommand(Uint8List.fromList(brizziBytes.sublist(0,9)));
        if(brizziResponse.isSuccess){
          print('brizziResponse.isSuccess');
          cardInfo = BrizziCardInfo(commandApi);
        }
      }catch(error){
        errorException = Exception(error.toString());
        LogUtil.d( "brizzi result connect to flash error :$error");
      }
    }

    if(cardInfo == null){
      try{

        var commandApi = AndroidIso7816CommandApi(_isoDep);
        CommandResponse tapResponse = await commandApi.sendCommand(Uint8List.fromList(tapBytes.sublist(0,13)));
        if(tapResponse.isSuccess){
          cardInfo = TapCashCardInfo(commandApi);
        }
      }catch(error){
        errorException = Exception(error.toString());
        LogUtil.d( "tap result connect to flash error :$error");
      }
    }

    if(cardInfo == null){
      try{
        var commandApi = AndroidJackCommandApi(_isoDep);
        CommandResponse jackResponse = await commandApi.sendCommand(Uint8List.fromList(jackBytes.sublist(0,13)));
        if(jackResponse.isSuccess){
          cardInfo = JackCardInfo(commandApi);
        }
      }catch(error){
        errorException = Exception(error.toString());
        LogUtil.d( "tap result connect to flash error :$error");
      }
    }

    if(cardInfo == null){
      if(errorException != null){
        throw errorException;
      }
      cardInfo = OtherCardInfo(null);
    }

    return cardInfo;
  }

  String getByteArr4String(Uint8List data){
    String s = '';
    for (int i = 0; i < data.length; i++) {
      if (i > 0) {
        s+=' ';
      }
      int i2 = data[i] & 255;
      if (i2 < 16) {
        s+= '0';
      }
      var hexString = i2.toRadixString(16);
      s+=hexString;
    }
    return s;

  }

  Future<bool> selectService() async {
    print('selectService');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList));
    return _transceiveSuccess(data);
  }


  Future<bool> selectService2() async {
    print('selectService2');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList2));
    return _transceiveSuccess(data);
  }

  Future<bool> selectService3() async {
    print('selectService3');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList3));
    return _transceiveSuccess(data);
  }

  Future<bool> selectService4() async {
    print('selectService4');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList4));
    return _transceiveSuccess(data);
  }

  Future<bool> selectService5() async {
    print('selectService5');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList5));
    return _transceiveSuccess(data);
  }

  Future<bool> selectService6() async {
    print('selectService6');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList6));
    return _transceiveSuccess(data);
  }

  Future<bool> selectService10() async {
    print('selectService10');
    var data = await _isoDep.transceive(data: Uint8List.fromList(appServiceList10));
    return _transceiveSuccess(data);
  }

  Future<String> getCardNum() async {
    var data = await _isoDep.transceive(data: Uint8List.fromList(cardNumList));
    bool isSuccess = _transceiveSuccess(data);
    if (!isSuccess) {
      throw Exception('could not retrieve msisdn');
    }
    return _transitionCardNum(data, 8);
  }

  Future<double?> getAmount() async {
    var data = await _isoDep.transceive(data: Uint8List.fromList(amountList));
    if (data.length < 4) {
      return null;
    }

    double money = 0.0;
    for (int i = 0; i < 4; i++) {
      money += (data[i] & 0xFF) << (i * 8);
    }
    return money;
  }



  bool _transceiveSuccess(Uint8List data) {
    var b1 = data[data.length - 2];
    var b2 = data[data.length - 1];
    return b1 == 0x90 && b2 == 0;
  }


  String _transitionCardNum(Uint8List data, int count) {
    Uint8List uint8list = Uint8List.fromList([
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
      list[j] = uint8list[a >>> 4];
      j = b + 1;
      list[b] = uint8list[a & 0x0F];
    }
    return String.fromCharCodes(list);
  }

}
