
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';

class EmailOtpState implements GlobalBaseState<EmailOtpState> {
  late TextEditingController emailController;
  late TextEditingController emailOtpController;
  late VerificationController sendController;
  FocusNode verifyFocusNode = FocusNode();
  @override
  EmailOtpState clone() {
    return EmailOtpState()
      ..emailController = emailController
      ..emailOtpController = emailOtpController
      ..sendController = sendController
      ..verifyFocusNode = verifyFocusNode
      ..languageResource = languageResource
      ..languageLocale = languageLocale

    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EmailOtpState initState(Map<String, dynamic>? args) {
  return EmailOtpState()
    ..emailOtpController = TextEditingController()
    ..emailController = TextEditingController()
    ..sendController = VerificationController()

  ;
}
