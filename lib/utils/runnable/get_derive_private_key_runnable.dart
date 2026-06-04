import 'dart:typed_data';

import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import '../scan_util.dart';

class GetDerivePrivateKeyRunnable extends CardSessionRunnable {
  String derivePathHex;
  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager
        .getDerivePrivateKey(Uint8List.fromList(hex.decode(derivePathHex)));
    if (response.isSuccess) {
      var data = response.data!;

      return ScanResponse(true, data: hex.encode(data));
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }

  GetDerivePrivateKeyRunnable(this.derivePathHex);
}
