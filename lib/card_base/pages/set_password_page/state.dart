
import 'package:flutter/material.dart';

import '../../../custom_widget/verification_button.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/setting_bean.dart';

class SetPasswordState extends LoadPageState<SetPasswordState> {
  late TextEditingController passwordController;
  late TextEditingController verifyController;
  late VerificationController sendController;
  late List<VerifyMethod> verifyMethods;
  late int index = 0;

  @override
  SetPasswordState clone() {
    return SetPasswordState()
      ..passwordController = passwordController
      ..verifyController = verifyController
      ..sendController = sendController
    ..verifyMethods = verifyMethods
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..errorMsg = errorMsg
      ..index = index
      ..loadStatus = loadStatus;
  }
}

SetPasswordState initState(Map<String, dynamic>? args) {
  return SetPasswordState()
    ..passwordController = TextEditingController()
    ..verifyController = TextEditingController()
    ..sendController = VerificationController()
    ..verifyMethods = [];
}
