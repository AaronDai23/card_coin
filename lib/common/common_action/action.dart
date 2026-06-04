

import 'package:fish_redux/fish_redux.dart';

enum CommonAction { loginOut,languageChanged }

class CommonActionCreator {

  static Action onLoginOut() {
    return const Action(CommonAction.loginOut);
  }
  static Action onLanguageChanged() {
    return const Action(CommonAction.languageChanged);
  }

}