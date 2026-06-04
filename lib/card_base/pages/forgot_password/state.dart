import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/cupertino.dart';

import '../../../custom_widget/verification_button.dart';
import '../../bean/country_register_info.dart';

class ForgotPasswordState implements LoadPageState<ForgotPasswordState> {
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController codeController;
  late TextEditingController pwdController;
  late TextEditingController confirmPwdController;
  late VerificationController verificationController;
  FocusNode verifyFocusNode = FocusNode();

  late List<CountryRegisterInfo> countryList = [];
  int selectedIndex = 0;

  bool isPhone = true;

  @override
  ForgotPasswordState clone() {
    return ForgotPasswordState()
      ..phoneController = phoneController
      ..emailController = emailController
      ..codeController = codeController
      ..pwdController = pwdController
      ..verifyFocusNode = verifyFocusNode
      ..countryList = countryList
      ..selectedIndex = selectedIndex
      ..languageLocale = languageLocale
      ..confirmPwdController = confirmPwdController
      ..verificationController = verificationController
      ..loadStatus = loadStatus
      ..isPhone = isPhone
      ..errorMsg = errorMsg
      ..languageResource = languageResource;
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

ForgotPasswordState initState(Map<String, dynamic>? args) {
  return ForgotPasswordState()
    ..isPhone = args?['isPhone'] ?? false
    ..codeController = TextEditingController()
    ..emailController = TextEditingController()
    ..pwdController = TextEditingController()
    ..confirmPwdController = TextEditingController()
    ..verificationController = VerificationController()
    ..phoneController = TextEditingController();
}
