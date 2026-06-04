import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

class GetDeriveInfoRunnable extends BaseRunnable {
  @override
  Future<ScanResponse<int>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([
      0x80,
      0x42,
      0x00,
      0x00,
    ]);
  }

  @override
  List<int> getData() {
    return [
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
    ];
  }

  @override
  ScanResponse<int> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      return ScanResponse(true, data: 0);
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
