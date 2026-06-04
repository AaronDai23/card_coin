import 'package:fish_redux/fish_redux.dart';

import '../../bean/update_info_bean.dart';

//TODO replace with your own action
enum SplashAction {
  checkUpdate,
  upgradeApp,
  startAppsFlyer,
  register,
}

class SplashActionCreator {
  static Action onCheckUpdate() {
    return const Action(SplashAction.checkUpdate);
  }

  static Action onUpgradeApp(UpdateInfo updateInfo) {
    return Action(SplashAction.upgradeApp, payload: updateInfo);
  }

  static Action onStartAppsFlyer() {
    return const Action(SplashAction.startAppsFlyer);
  }

  static Action onRegister(Map deeplinks) {
    return Action(SplashAction.register, payload: deeplinks);
  }
}
