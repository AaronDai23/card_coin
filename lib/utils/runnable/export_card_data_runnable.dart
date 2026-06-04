import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

/// 导出卡片数据
class ExportCardDataRunnable extends BaseRunnable {
  ExportCardDataRunnable({required this.pinCode});

  final List<int> pinCode;

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x45, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return [0x95, pinCode.length, ...pinCode];
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    print("response.isSuccess:${response.isSuccess},data:${response.data!}");
    if (response.isSuccess) {
      final originData = response.data!;
      int length = originData[1];
      final cardData = originData.sublist(2, 2 + length);
      String data = HexUtils.uint8ListToHex(cardData);
      return ScanResponse(
        true,
        data: data,
        sw1: response.sw1,
        sw2: response.sw2,
      );
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
