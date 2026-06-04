import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../global_store/state.dart';
import '../../../bean/activate_info.dart';
import '../../../bean/validate_method.dart';

class EmailActivateState implements GlobalBaseState<EmailActivateState> {
  late TextEditingController emailController;
  late TextEditingController inviteController;
  late String uuid;
  late ValidateMethod method;
  ActivateInfo? activateInfo;
  int step = 0;
  int activateType = 0;
  @override
  EmailActivateState clone() {
    return EmailActivateState()
      ..emailController = emailController
      ..inviteController = inviteController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..activateInfo = activateInfo
      ..step = step
      ..uuid = uuid
      ..method = method
      ..activateType = activateType

    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EmailActivateState initState(Map<String, dynamic>? args) {
  return EmailActivateState()
    ..uuid = args!['uuid']
    ..method = args['method']
    ..emailController = TextEditingController()
    ..inviteController = TextEditingController();
}
