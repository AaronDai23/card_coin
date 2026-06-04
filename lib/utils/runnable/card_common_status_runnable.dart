import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/material.dart';

import '../../bean/health_check_bean.dart';
import '../scan_util.dart';

///查询公钥
class CardCommonStatusRunnable extends BaseRunnable {
  CardCommonStatusRunnable();

  @override
  Future<ScanResponse<CardHealthCommonStatus?>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.sendCommand(getHeader());
    return handleResponse(response, cardId: readerManager.cardId);
  }

  @override
  ScanResponse<CardHealthCommonStatus?> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;
      CardHealthCommonStatus commonStatus =
          CardHealthCommonStatus.fromData(cardId, data);
          

      return ScanResponse(true, data: commonStatus);
    } else {
      return ScanResponse(false,
          sw1: response.sw1, sw2: response.sw2, message: response.message);
    }
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x31, 0x00, 0x00]);
  }
}
