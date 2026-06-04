
import 'package:card_coin/card_base/bean/system_config.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

import '../../../cache/bean/user_info_bean.dart';
import '../../../cache/local_storage.dart';
import '../../../custom_widget/verification_button.dart';
import '../../../global_store/state.dart';

class BindEmailState implements GlobalBaseState<BindEmailState>,PageLoad {
  late TextEditingController emailController;
  late TextEditingController pwdController;
  late TextEditingController emailVerifyController;
  late VerificationController emailSendController;
  FocusNode verifyFocusNode = FocusNode();
  String? title;
  UserInfo? userInfo;

  SystemConfig? systemConfig;
  @override
  BindEmailState clone() {
    return BindEmailState()
      ..title = title
      ..userInfo = userInfo
      ..emailController = emailController
      ..pwdController = pwdController
      ..verifyFocusNode = verifyFocusNode
      ..emailVerifyController = emailVerifyController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..systemConfig = systemConfig
      ..emailSendController = emailSendController;
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

BindEmailState initState(Map<String, dynamic>? args) {
  var userInfo = LocalStorage.getCacheUserInfo();
  print('userinfo email:${userInfo?.customer?.email}');
  return BindEmailState()
    ..title = args?['title']
    ..userInfo = userInfo
    ..emailController = TextEditingController()
    ..pwdController = TextEditingController()
    ..emailVerifyController = TextEditingController()
    ..emailSendController = VerificationController();
}
