
import 'package:fish_redux/fish_redux.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../cache/bean/user_info_bean.dart';
import 'bean/language_model.dart';

//TODO replace with your own action
enum AppVersionAction { action,init,selectLanguage,loadSuccess,loadFailure,updateCurrentIndex }

class AppVersionActionCreator {


  static Action onAction() {
    return const Action(AppVersionAction.action);
  }

  static Action onUpdateCurrentIndex(int index) {
    return Action(AppVersionAction.updateCurrentIndex,payload: index);
  }

  static Action onInit(UserInfo? userInfo,PackageInfo packageInfo) {
    return Action(AppVersionAction.init,payload: {'userInfo':userInfo,'packageInfo':packageInfo});
  }

  static Action onSelectLanguage() {
    return const Action(AppVersionAction.selectLanguage);
  }

  static Action onLoadSuccess(List<LanguageModel> languageList) {
    return Action(AppVersionAction.loadSuccess,payload: languageList);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(AppVersionAction.loadFailure,payload: errorMsg);
  }
}
