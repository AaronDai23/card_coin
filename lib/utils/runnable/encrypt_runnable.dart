import 'dart:typed_data';

import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:flutter/cupertino.dart';

import '../../managers/isodep_reader_manager.dart';
import '../aes_util.dart';
import '../hex_utils.dart';
import '../scan_util.dart';

class EncryptRunnable extends BaseRunnable {
  final String data;

  EncryptRunnable(this.data);

  @override
  Future<ScanResponse<Map<String, dynamic>>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.sendCommand(getHeader(),
        data: getData(), encrypt: false);
    return handleResponse(response, encryptKey: readerManager.encryptKey);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x9C, 0x00, 0x00]);
  }

  @override
  List<int> getData() {
    return data.codeUnits;
  }

  @override
  ScanResponse<Map<String, dynamic>> handleResponse(CommandResponse response,
      {String cardId = '',
      bool? isActivated,
      List<int>? encryptKey,
      int resetCount = 0}) {
    if (response.isSuccess) {
      Uint8List bytes = Uint8List.fromList(data.codeUnits);
      final temp = bytes.length % 16;
      if (temp != 0) {
        bytes = Uint8List.fromList(
            [...bytes, ...List.generate(16 - temp, (index) => 0)]);
      }

      final appData = AesUtil.encryptData(encryptKey!, bytes);

      return ScanResponse(true, data: {
        'appData': HexUtils.uint8ListToHex(appData),
        'cardData': HexUtils.uint8ListToHex(response.data!)
      });
    } else {
      return ScanResponse(false,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }
}
