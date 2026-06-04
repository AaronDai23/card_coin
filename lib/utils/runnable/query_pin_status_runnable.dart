import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/runnable/bean/pin_code_info.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../scan_util.dart';

class QueryPinStatusRunnable extends BaseRunnable {
  @override
  Future<ScanResponse<PinCodeInfo>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.sendCommand(getHeader());
    if (response.isSuccess) {
      var data = response.data!;
      if (data[2] == 0) {
        return ScanResponse(true, data: PinCodeInfo(isOpen: false));
      } else {
        var countResponse = await readerManager.queryPinCodeCount();
        if (countResponse.isSuccess) {
          return ScanResponse(true,
              data:
                  PinCodeInfo(isOpen: true, pinCount: countResponse.data![2]));
        } else {
          return ScanResponse(false,
              message: countResponse.message,
              sw1: countResponse.sw1,
              sw2: countResponse.sw2);
        }
      }
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }

  @override
  ScanResponse handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;
      return ScanResponse(true, data: data[2]);
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x54, 0x00, 0x00]);
  }
}
