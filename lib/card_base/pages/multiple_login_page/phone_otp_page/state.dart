import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../custom_widget/verification_button.dart';
import '../../../bean/country_register_info.dart';

class PhoneOtpState implements GlobalBaseState<PhoneOtpState> {
  late TextEditingController phoneController;
  late TextEditingController phoneOtpController;
  late VerificationController sendController;
  late List<CountryRegisterInfo> countryList;
  late int selectedIndex;
  FocusNode verifyFocusNode = FocusNode();

  @override
  PhoneOtpState clone() {
    return PhoneOtpState()
      ..phoneController = phoneController
      ..phoneOtpController = phoneOtpController
      ..sendController = sendController
      ..verifyFocusNode = verifyFocusNode
      ..countryList = countryList
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..selectedIndex = selectedIndex;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

PhoneOtpState initState(Map<String, dynamic>? args) {
  List<CountryRegisterInfo> countryList = args!['countryList'];
  return PhoneOtpState()
    ..countryList = countryList
    ..selectedIndex = 0
    ..phoneController = TextEditingController()
    ..phoneOtpController = TextEditingController()
    ..sendController = VerificationController();
}
