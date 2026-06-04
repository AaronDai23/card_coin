import 'dart:typed_data';

import 'package:card_coin/bean/health_check_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/utils/runnable/base_runnable.dart';
import 'package:card_coin/utils/runnable/bean/compatibility_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../managers/isodep_reader_manager.dart';
import '../scan_util.dart';

class GetNdefDataRunnable extends BaseRunnable {
  GetNdefDataRunnable();

  @override
  Future<ScanResponse<String>> run(
      BuildContext context, IsoDepReaderManager readerManager) async {
    var response = await readerManager.sendCommand(getHeader());
    return handleResponse(response);
  }

  @override
  Uint8List getHeader() {
    return Uint8List.fromList([0x80, 0x62, 0x00, 0x00]);
  }

  @override
  ScanResponse<String> handleResponse(CommandResponse response,
      {String cardId = '', bool? isActivated, int resetCount = 0}) {
    if (response.isSuccess) {
      var data = response.data!;

      int ndefLenght = data[1];
      String ndefUrl = String.fromCharCodes(data.sublist(2, 2 + ndefLenght));
      //
      print("GetNdefDataRunnable-ndefData:$ndefUrl");

      return ScanResponse(true, data: ndefUrl);
    } else {
      return ScanResponse(false, message: response.message);
    }
  }

  @override
  Future<ScanResponse<CompatibilityInfo>> commonRun(
      BuildContext context, IsoDepReaderManager readerManager) async {
    final response = await readerManager.queryCardStatus();
    if (response.isSuccess) {
      CardHealthCommonStatus commonStatus =
          CardHealthCommonStatus.fromData(readerManager.cardId, response.data!);
      var packageInfo = await PackageInfo.fromPlatform();
      String key =
          "${commonStatus.uuid}_${commonStatus.cardVersionCode}_${packageInfo.buildNumber}";
      CompatibilityInfo? compatibility =
          await LocalStorage.getCompatibility(key);
      print("GetNdefDataRunnable:commonRun:key:$key");
      if (compatibility != null) {
        // 说明之前存储过,这种情况下可以不用请求兼容性接口
        print("GetNdefDataRunnable:commonRun::${compatibility.result}");
        return ScanResponse(true,
            data: compatibility, commonInfo: commonStatus);
      } else {
        // 说明之前没有存储过,需要请求兼容性接口
        return ScanResponse(true,
            data: CompatibilityInfo(data: PageCategoryItem()),
            commonInfo: commonStatus);
      }
    } else {
      return ScanResponse(true,
          message: response.message, sw1: response.sw1, sw2: response.sw2);
    }
  }

  @override
  List<int> getData() {
    return [];
  }
}
