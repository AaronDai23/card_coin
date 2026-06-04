import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

/// 导出卡片数据
class ImportCardDataRunnable extends BaseRunnable {
  ImportCardDataRunnable({required this.pinCode, required this.cardData});

  final List<int> pinCode;
  final String cardData;

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x46, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    Uint8List cardCode = HexUtils.hexStringToUint8List(cardData);
    return [
      0x91,
      cardCode.length,
      ...cardCode,
      0x95,
      pinCode.length,
      ...pinCode
    ];
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      String data = HexUtils.uint8ListToHex(response.data!);
      return ScanResponse(true, data: data);
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
