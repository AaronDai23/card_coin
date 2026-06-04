
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

import '../../../custom_widget/verification_button.dart';
import '../../../global_store/state.dart';
import '../../bean/country_register_info.dart';
import '../../bean/system_config.dart';

class BindPhoneState implements GlobalBaseState<BindPhoneState>,PageLoad {
  late TextEditingController phoneController;
  late TextEditingController verifyController;
  late VerificationController sendController;
  late TextEditingController passwordController;
  List<CountryRegisterInfo> countryList = [];
  int selectedIndex = 0;
  String? title;
  FocusNode verifyFocusNode = FocusNode();

  SystemConfig? systemConfig;
  @override
  BindPhoneState clone() {
    return BindPhoneState()
      ..phoneController = phoneController
      ..verifyController = verifyController
      ..sendController = sendController
      ..passwordController = TextEditingController()
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..verifyFocusNode = verifyFocusNode
      ..selectedIndex = selectedIndex
      ..countryList = countryList
      ..systemConfig = systemConfig
      ..title = title
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
    ;
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

BindPhoneState initState(Map<String, dynamic>? args) {
  return BindPhoneState()
    ..title = args?['title']
    ..phoneController = TextEditingController()
    ..verifyController = TextEditingController()
    ..sendController = VerificationController()
  ;
}
