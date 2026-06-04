
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../global_store/state.dart';

class UpdatePasswordState implements GlobalBaseState<UpdatePasswordState> {
  late TextEditingController oldPwdController;
  late TextEditingController pwdController;
  late TextEditingController confirmPwdController;
  String? title;
  @override
  UpdatePasswordState clone() {
    return UpdatePasswordState()
      ..oldPwdController = oldPwdController
      ..pwdController = pwdController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..confirmPwdController = confirmPwdController
      ..title = title
    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

UpdatePasswordState initState(Map<String, dynamic>? args) {
  return UpdatePasswordState()
    ..title = args?['title']
    ..oldPwdController = TextEditingController()
    ..pwdController = TextEditingController()
    ..confirmPwdController = TextEditingController()
  ;
}
