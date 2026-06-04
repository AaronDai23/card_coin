import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

class SignatureRunnable extends BaseRunnable {
  @override
  Future<ScanResponse<int>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.signature();
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([
      0x80,
      0x32,
      0x00,
      0x00,
    ]);
  }

  @override
  List<int> getData() {
    return [
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
