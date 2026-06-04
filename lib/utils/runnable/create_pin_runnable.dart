import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../scan_util.dart';

class CreatePinRunnable extends BaseRunnable {
  late List<int> pinCode;
  CreatePinRunnable(this.pinCode);

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x50, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return [0x95, pinCode.length, ...pinCode];
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;
      final puk = data.sublist(2).map((e) => e.toString()).join();
      print("CreatePinRunnable-puk:$puk");
      return ScanResponse(true, data: puk);
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
