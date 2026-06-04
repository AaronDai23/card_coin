import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

enum GlobalAction { changeThemeColor,changeLanguage,initLocalization }

class GlobalActionCreator {
  static Action onchangeThemeColor(Color color) {
    return Action(GlobalAction.changeThemeColor,payload: color);
  }

  static Action onChangeLanguage(Locale locale) {
    return Action(GlobalAction.changeLanguage,payload: locale);
  }

  static Action onInitLocalization(Map<String,dynamic> messages) {
    return Action(GlobalAction.initLocalization,payload: messages);
  }
}
