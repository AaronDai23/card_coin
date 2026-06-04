import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../scan_util.dart';

class UpdatePinRunnable extends BaseRunnable {
  late List<int> pinCode;
  late List<int> newPinCode;
  UpdatePinRunnable({required this.pinCode, required this.newPinCode});

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x51, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return [
      0x95,
      pinCode.length,
      ...pinCode,
      0x95,
      newPinCode.length,
      ...newPinCode
    ];
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      return ScanResponse(true, data: '');
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
