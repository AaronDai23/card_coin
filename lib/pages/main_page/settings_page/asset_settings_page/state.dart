import 'package:card_coin/card_base/bean/crypto_setting_info.dart';

import '../../../../widget/base_page_loading.dart';

class AssetSettingsState extends LoadPageState<AssetSettingsState> {

  late String uid;
  List<CryptoSettingInfo> list = [];
  @override
  AssetSettingsState clone() {
    return AssetSettingsState()
      ..uid = uid
      ..languageResource = languageResource
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..loadStatus = loadStatus
      ..list = list
    ;
  }
}

AssetSettingsState initState(Map<String, dynamic>? args) {
  String uid = args!['cardId'];
  return AssetSettingsState()..uid = uid;
}
