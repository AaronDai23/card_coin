import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import '../../../../global_store/state.dart';

class PhoneRegisterState implements GlobalBaseState<PhoneRegisterState> {
  late TextEditingController phoneController;
  late TextEditingController verifyController;
  late TextEditingController inviteController;
  late TextEditingController passwordController;
  late VerificationController sendController;
  late int tabIndex;
  late int selectedIndex;
  String uid = '';
  String taskItemId = '';
  late List<CountryRegisterInfo> countryList;
  FocusNode verifyFocusNode = FocusNode();
  @override
  PhoneRegisterState clone() {
    return PhoneRegisterState()
      ..passwordController = passwordController
      ..phoneController = phoneController
      ..inviteController = inviteController
      ..verifyController = verifyController
      ..sendController = sendController
      ..countryList = countryList
      ..selectedIndex = selectedIndex
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

PhoneRegisterState initState(Map<String, dynamic>? args) {
  List<CountryRegisterInfo> countryList = args!['countryList'];
  String uid = args['uid'] ?? '';
  String taskItemId = args['taskItemId'] ?? '';
  return PhoneRegisterState()
    ..tabIndex = args['index']
    ..countryList = countryList
    ..selectedIndex = 0
    ..phoneController = TextEditingController()
    ..uid = uid
    ..taskItemId = taskItemId
    ..verifyController = TextEditingController()
    ..inviteController = TextEditingController()
    ..passwordController = TextEditingController()
    ..sendController = VerificationController();
}
