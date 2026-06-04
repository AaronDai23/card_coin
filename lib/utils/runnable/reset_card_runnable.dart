import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

class ResetCardRunnable extends BaseRunnable {
  List<int>? pinCode;

  @override
  Future<ScanResponse<int>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  ResetCardRunnable({this.pinCode});

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x44, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    String timeStr = DateTime.now().millisecondsSinceEpoch.toString();
    List<int> list = timeStr.codeUnits;
    List<int> data = [0x97, 0x0D, ...list];
    if (pinCode != null) {
      data.addAll([0x95, pinCode!.length, ...pinCode!]);
    }
    return data;
  }

  @override
  ScanResponse<int> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;
      return ScanResponse(true, data: data[2]);
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
