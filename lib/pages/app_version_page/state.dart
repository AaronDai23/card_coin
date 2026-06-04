
import 'package:package_info_plus/package_info_plus.dart';

import '../../cache/bean/user_info_bean.dart';
import '../../widget/base_page_loading.dart';
import 'bean/language_model.dart';

class AppVersionState extends LoadPageState<AppVersionState> {

  UserInfo? userInfo;
  PackageInfo? packageInfo;
  List<LanguageModel> languageList = [];
  int currentIndex = 0;
  String? title;
  @override
  AppVersionState clone() {
    return AppVersionState()
      ..userInfo = userInfo
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..packageInfo = packageInfo
      ..loadStatus = loadStatus
      ..currentIndex = currentIndex
      ..languageList = languageList
      ..errorMsg = errorMsg
      ..title = title
    ;
  }
}

AppVersionState initState(Map<String, dynamic>? args) {
  return AppVersionState()
    ..loadStatus = LoadType.loading
    ..title = args?['title']
  ;
}
