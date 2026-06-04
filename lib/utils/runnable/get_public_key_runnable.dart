
import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/utils/hex_utils.dart';
import 'package:flutter/material.dart';

import '../scan_util.dart';
import 'base_runnable.dart';

class GetPublicKeyRunnable extends BaseRunnable {
  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.getPublicKey();
    if (response.isSuccess) {
      var data = response.data!;
      return ScanResponse(true, data: HexUtils.uint8ListToHex(data));
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}