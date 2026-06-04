import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../cache/bean/user_info_bean.dart';
import '../../../../cache/local_storage.dart';
import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../http/result_data.dart';
import '../../../../utils/string_util.dart';
import 'action.dart';
import 'state.dart';

Effect<EmailPasswordState>? buildEffect() {
  return combineEffects(<Object, Effect<EmailPasswordState>>{
    EmailPasswordAction.loginClick: _onLoginClick,
  });
}

Future<void> _onLoginClick(Action action, Context<EmailPasswordState> ctx) async {
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  String password = ctx.state.emailPwdController.text;
  if (emailAddress.isEmpty) {
    showToast(languageResource.enterEmail);
    return;
  }

  if (password.isEmpty) {
    showToast(languageResource.enterPwd);
    return;
  }

  if (!StringUtils.isEmail(emailAddress)){
    showToast(languageResource.emailError);
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? deviceName;

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String versionCode = packageInfo.buildNumber;
  String versionName = packageInfo.version;
  if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    deviceName = androidDeviceInfo.model;
  } else if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    deviceName = iosDeviceInfo.model;
  }

  var params = {
    "credential": password,
    "identifierCarrier": 'EMAIL',
    "identityType": "PASSWORD",
    "identifier": emailAddress,
    'platform': Platform.isAndroid ? 'android' : 'ios',
    'deviceId': '123456',
    'deviceName': deviceName,
    'versionCode': versionCode,
    'versionName': versionName,
  };

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.loginMultipleUrl, null, data: params);

  pr.hide();
  if (result.isSuccess) {
    var userInfo = UserInfo.fromJson(result.data);
    LocalStorage.saveUserInfo(userInfo);
    AppsflyerSdk(null).logEvent('login_to_main_page', {'id':userInfo.customer!.customerCode});
    Navigator.pushNamedAndRemoveUntil(ctx.context, 'cardBaseMainPage', (route) => false,
        arguments: {'userInfo': userInfo});
  } else {
    print('error :${result.message}');
    showToast(result.message);
  }
}
