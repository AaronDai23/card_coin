import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

import '../../../custom_widget/verification_button.dart';
import '../../../global_store/state.dart';
import '../../bean/login_bean.dart';

class RegisterState implements GlobalBaseState<RegisterState>, PageLoad {
  late TextEditingController phoneController;
  late TextEditingController verifyController;
  late TextEditingController inviteController;
  late TextEditingController passwordController;
  late VerificationController sendController;
  int currentIndex = 0;
  String uid = '';
  String taskItemId = '';

  FocusNode verifyFocusNode = FocusNode();
  bool isAgree = false;
  // late List<RegisterType> registerTypeList = [
  //   RegisterType.email,
  //   RegisterType.phone
  // ];
  List<CountryRegisterInfo> countryList = [];
  late List<LoginMethod> registerMethodList;

  @override
  RegisterState clone() {
    return RegisterState()
      ..passwordController = passwordController
      ..phoneController = phoneController
      ..inviteController = inviteController
      ..verifyController = verifyController
      ..sendController = sendController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..countryList = countryList
      ..isAgree = isAgree
      ..currentIndex = currentIndex
      ..verifyFocusNode = verifyFocusNode
      ..registerMethodList = registerMethodList
      ..uid = uid
      ..taskItemId = taskItemId
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;
}

RegisterState initState(Map<String, dynamic>? args) {
  final uid = args?['uid'];
  final taskItemId = args?['taskItemId'];

  return RegisterState()
    ..phoneController = TextEditingController()
    ..verifyController = TextEditingController()
    ..inviteController = TextEditingController()
    ..passwordController = TextEditingController()
    ..uid = uid ?? ''
    ..taskItemId = taskItemId ?? ''
    ..sendController = VerificationController()
    ..registerMethodList = [];
}
