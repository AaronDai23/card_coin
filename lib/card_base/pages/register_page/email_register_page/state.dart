import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import '../../../../global_store/state.dart';

class EmailRegisterState implements GlobalBaseState<EmailRegisterState> {
  late TextEditingController emailController;
  late TextEditingController verifyController;
  late TextEditingController inviteController;
  late TextEditingController passwordController;
  late VerificationController sendController;
  FocusNode verifyFocusNode = FocusNode();
  late int tabIndex;
  String uid = '';
  String taskItemId = '';

  @override
  EmailRegisterState clone() {
    return EmailRegisterState()
      ..passwordController = passwordController
      ..emailController = emailController
      ..inviteController = inviteController
      ..verifyController = verifyController
      ..sendController = sendController
      ..languageLocale = languageLocale
      ..verifyFocusNode = verifyFocusNode
      ..languageResource = languageResource
      ..uid = uid
      ..taskItemId = taskItemId
      ..tabIndex = tabIndex;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EmailRegisterState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'] ?? '';
  String taskItemId = args['taskItemId'] ?? '';
  return EmailRegisterState()
    ..uid = uid
    ..taskItemId = taskItemId
    ..emailController = TextEditingController()
    ..verifyController = TextEditingController()
    ..inviteController = TextEditingController()
    ..passwordController = TextEditingController()
    ..sendController = VerificationController();
}
