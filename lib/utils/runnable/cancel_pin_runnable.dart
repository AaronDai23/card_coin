import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../hex_utils.dart';
import '../scan_util.dart';

class CancelPinRunnable extends BaseRunnable {
  late List<int> pinCode;
  late List<int> pukCode;
  CancelPinRunnable({required this.pinCode, required this.pukCode});

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response =
        await readerManager.sendCommand(getHeader(), data: getData());
    return handleResponse(response);
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    print(
        "CancelPinRunnable-response-data:${HexUtils.uint8ListToHex(response.data ?? Uint8List(0))}");
    if (response.isSuccess) {
      return ScanResponse(true, data: '');
    } else if (response.sw1 == 0x6A && response.sw2 == 0x82) {
      // PIN code is incorrect
      return ScanResponse(false,
          message: 'PIN code is incorrect',
          sw1: response.sw1,
          sw2: response.sw2);
    } else if (response.sw1 == 0x6A && response.sw2 == 0x83) {
      // PUK code is incorrect
      return ScanResponse(false,
          message: 'PUK code is incorrect',
          sw1: response.sw1,
          sw2: response.sw2);
    } else if (response.isSuccess) {
      return ScanResponse(true, data: '');
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x57, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return [0x96, pukCode.length, ...pukCode, 0x95, pinCode.length, ...pinCode];
  }
}
