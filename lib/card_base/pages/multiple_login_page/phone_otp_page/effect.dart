import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../cache/bean/user_info_bean.dart';
import '../../../../cache/local_storage.dart';
import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../http/result_data.dart';
import 'action.dart';
import 'state.dart';

Effect<PhoneOtpState>? buildEffect() {
  return combineEffects(<Object, Effect<PhoneOtpState>>{
    PhoneOtpAction.loginClick: _onLoginClick,
    PhoneOtpAction.sendLoginVerifyCode: _onSendLoginVerifyCode,
  });
}

Future<void> _onSendLoginVerifyCode(
    Action action, Context<PhoneOtpState> ctx) async {
  KeyboardService.dismiss();
  String phoneNum = ctx.state.phoneController.text;
  if (phoneNum.isEmpty) {
    showToast(ctx.state.languageResource!.enterPhoneNo,
        position: const ToastPosition(offset: 150));
    return;
  }
  final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
  final mathPhone = RegExp(currentCountry.phoneRegx ?? '').hasMatch(phoneNum);
  if (!mathPhone) {
    showToast(ctx.state.languageResource!.phoneFormatError,
        position: const ToastPosition(offset: 150));
    return;
  }

  var params = {
    'identityCarrier': 'MOBILE',
    'identifier': phoneNum,
    'isoCode': currentCountry.isoCode
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.sendLoginVerityCodeUrl, null, data: params);
  await pr.hide();
  if (resultData.isSuccess) {
    showToast(ctx.state.languageResource!.sendCodeSuccess,
        position: const ToastPosition(offset: 150));
    ctx.state.sendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(resultData.message, position: const ToastPosition(offset: 150));
  }
}

Future<void> _onLoginClick(Action action, Context<PhoneOtpState> ctx) async {
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  String phoneNum = ctx.state.phoneController.text;
  String otpCode = ctx.state.phoneOtpController.text;
  if (phoneNum.isEmpty) {
    showToast(ctx.state.languageResource!.enterPhoneNo,
        position: const ToastPosition(offset: 150));
    return;
  }

  final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
  final mathPhone = RegExp(currentCountry.phoneRegx ?? '').hasMatch(phoneNum);
  if (!mathPhone) {
    showToast(ctx.state.languageResource!.phoneFormatError,
        position: const ToastPosition(offset: 150));
    return;
  }

  if (otpCode.isEmpty) {
    showToast(ctx.state.languageResource!.enterPhoneCode,
        position: const ToastPosition(offset: 150));
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
    "code": otpCode,
    "isoCode": currentCountry.isoCode,
    "identifierCarrier": 'MOBILE',
    "identityType": "OTP",
    "identifier": phoneNum,
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
    AppsflyerSdk(null).logEvent(
        'login_to_main_page', {'id': userInfo.customer!.customerCode});
    Navigator.pushNamedAndRemoveUntil(
        ctx.context, 'cardBaseMainPage', (route) => false,
        arguments: {'userInfo': userInfo});
  } else {
    print('error :${result.message}');
    showToast(result.message, position: const ToastPosition(offset: 150));
  }
}
