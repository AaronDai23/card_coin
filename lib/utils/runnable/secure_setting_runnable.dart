import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../scan_util.dart';

class SecureSettingRunnable extends BaseRunnable {
  final bool isOpen;

  SecureSettingRunnable(this.isOpen);

  @override
  Future<ScanResponse<int>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x9B, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return [isOpen ? 0x01 : 0x00];
  }

  @override
  ScanResponse<int> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      return ScanResponse(true);
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
