import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

/// 汇总数据
class QueryCardStatusRunnable extends BaseRunnable {
  QueryCardStatusRunnable();

  @override
  Future<ScanResponse<List>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x31, 0x00, 0x00]);
  }

  @override
  ScanResponse<List> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;
      // 1
      bool keyPairGenerated = data[2] == 0 ? false : true;
      //2
      bool pinSet = data[5] == 0 ? false : true;
      // 3
      int ndefLenght = data[7];
      String ndefStr = String.fromCharCodes(data.sublist(8, 8 + ndefLenght));
      // 4
      int pinRemainningTagIndex = data.indexOf(0x9C);
      int pinRemainning = data[pinRemainningTagIndex + 2];
      //5
      int pukRemainningTagIndex = data.indexOf(0x9D);
      int pukRemainning = data[pukRemainningTagIndex + 2];
      // 6
      int cardLockTagIndex = data.indexOf(0x9E);
      bool cardLock = data[cardLockTagIndex + 2] == 0 ? false : true;
      // 7
      int cardDisableTagIndex = data.indexOf(0x9F);
      bool cardDisable = data[cardDisableTagIndex + 2] == 0 ? false : true;
      // 8
      int versionIndex = data.indexOf(0xA0);
      int versionLenght = data[versionIndex + 1];
      String versionStr = String.fromCharCodes(
          data.sublist(versionIndex + 2, versionIndex + 2 + versionLenght));
      // 9
      int signTimesIdex = data.indexOf(0xA1);
      int signTimes = data[signTimesIdex + 2];

      List arr = [
        {'status': versionStr, 'content': versionStr, 'id': "CardVersion"},
        {'status': cardLock, 'content': '', 'id': "CardLock"},
        {'status': cardDisable, 'content': '', 'id': "CardDisable"},
        {'status': keyPairGenerated, 'content': "", 'id': "KeyPairGenerated"},
        {'status': pinSet, 'content': "", 'id': "PinSet"},
        {'status': pinRemainning, 'content': '', 'id': "PINRemainning"},
        {'status': pukRemainning, 'content': '', 'id': "PUKRemainning"},
        {'status': ndefStr, 'content': ndefStr, 'id': "NDEFPrefixSet"},
        {'status': signTimes, 'content': "", 'id': "signTimes"},
      ];

      return ScanResponse(true, data: arr);
    } else {
      return ScanResponse(
        false,
        message: response.message,
        sw1: response.sw1,
        sw2: response.sw2,
      );
    }
  }
}
