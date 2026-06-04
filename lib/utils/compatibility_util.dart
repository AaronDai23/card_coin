import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/runnable/bean/compatibility_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CompatibilityUtil {
  ///
  static void updateCompatibilitySmartCard(
      String uid, String appletVersionCode, String appletVersion) async {
    var result = await HttpManager.getInstance().post(
        NetworkAddress.compatibilitySmartCard, null,
        data: {'uid': uid, 'appletVersionCode': appletVersionCode});

    var packageInfo = await PackageInfo.fromPlatform();
    String key = "${uid}_${appletVersionCode}_${packageInfo.buildNumber}";
    String keyAppletVersionCode = "${uid}_appletVersionCode";
    String keyAppletVersion = "${uid}_appletVersion1";
    print("CompatibilityUtil:updateCompatibilitySmartCard:key:$key");
    // 获取当前时间
    // DateTime now = DateTime.now();
    // int timestampInSeconds = now.millisecondsSinceEpoch;
    if (result.isSuccess) {
      CompatibilityInfo info =
          CompatibilityInfo(result: true, data: PageCategoryItem());
      await LocalStorage.saveCompatibility(key, info);
      await LocalStorage.saveString(keyAppletVersionCode, appletVersionCode);
      await LocalStorage.saveString(keyAppletVersion, appletVersion);
    } else {
      if (result.code == 83010) {
        CompatibilityInfo info = CompatibilityInfo(
            result: false,
            message: result.message,
            data: PageCategoryItem.fromJson(result.data));
        await LocalStorage.saveCompatibility(key, info);
        await LocalStorage.saveString(keyAppletVersionCode, appletVersionCode);
        await LocalStorage.saveString(keyAppletVersion, appletVersion);
      }
    }
  }
}
