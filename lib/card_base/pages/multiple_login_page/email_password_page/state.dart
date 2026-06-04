import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

class EmailPasswordState implements GlobalBaseState<EmailPasswordState> {
  late TextEditingController emailController;
  late TextEditingController emailPwdController;

  @override
  EmailPasswordState clone() {
    return EmailPasswordState()
    ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..emailController = emailController
      ..emailPwdController = emailPwdController;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EmailPasswordState initState(Map<String, dynamic>? args) {
  return EmailPasswordState()
    ..emailPwdController = TextEditingController()
    ..emailController = TextEditingController();
}
