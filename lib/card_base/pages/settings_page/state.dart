import 'package:card_coin/pages/app_version_page/bean/language_model.dart';

import '../../../cache/bean/user_info_bean.dart';
import '../../../cache/local_storage.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/page_categroy_item.dart';

class SettingsState extends LoadPageState<SettingsState> {
  late UserInfo userInfo;
  late List<PageCategoryItem> list;
  int unreadCount = 0;
  int currentIndexLan = 0;
  List<LanguageModel> languageList = [];

  String? domain;
  @override
  SettingsState clone() {
    return SettingsState()
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..list = list
      ..domain = domain
      ..unreadCount = unreadCount
      ..currentIndexLan = currentIndexLan
      ..languageList = languageList
      ..userInfo = userInfo;
  }
}

SettingsState initState(Map<String, dynamic>? args) {
  UserInfo userInfo = LocalStorage.getCacheUserInfo()!;
  return SettingsState()
    ..list = []
    ..loadStatus = LoadType.loadSuccess
    ..userInfo = userInfo;
}
