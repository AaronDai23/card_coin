import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:card_coin/utils/login_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../cache/bean/user_info_bean.dart';
import '../../../../cache/local_storage.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../http/result_data.dart';
import 'action.dart';
import 'state.dart';

Effect<PhonePasswordState>? buildEffect() {
  return combineEffects(<Object, Effect<PhonePasswordState>>{
    Lifecycle.initState: _onInit,
    PhonePasswordAction.loginClick: _onLoginClick,
  });
}

Future<void> _onInit(Action action, Context<PhonePasswordState> ctx) async {
  if (ctx.state.countryList.isNotEmpty) {
    await savePhonePasswordCountryCache(ctx.state.countryList);
    return;
  }

  final isValidCache = await isPhonePasswordCountryCacheValid();
  if (!isValidCache) {
    return;
  }

  final cachedRaw = await LocalStorage.getString(phonePasswordCountryCacheKey);
  final cachedCountryList = parseCountryCache(cachedRaw);
  if (cachedCountryList.isNotEmpty) {
    ctx.dispatch(
        PhonePasswordActionCreator.onUpdateCountryList(cachedCountryList));
  }
}

Future<void> _onLoginClick(
    Action action, Context<PhonePasswordState> ctx) async {
  FocusScope.of(ctx.context).requestFocus(FocusNode());

  String phoneNum = ctx.state.phoneController.text;
  String password = ctx.state.phonePwdController.text;
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

  if (password.isEmpty) {
    showToast(ctx.state.languageResource!.enterPwd,
        position: const ToastPosition(offset: 150));
    return;
  }

  EasyLoading.show(status: 'loading...');

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
    'isoCode': currentCountry.isoCode,
    "identifierCarrier": 'MOBILE',
    "identityType": "PASSWORD",
    "identifier": phoneNum,
    'platform': Platform.isAndroid ? 'android' : 'ios',
    'deviceId': '123456',
    'deviceName': deviceName,
    'versionCode': versionCode,
    'versionName': versionName,
  };

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.loginMultipleUrl, null, data: params);
  if (result.isSuccess) {
    var userInfo = UserInfo.fromJson(result.data);
    LocalStorage.saveUserInfo(userInfo);

    // 检查是否有需要跳转的目标页面
    Map<String, dynamic>? targetRoute =
        await LoginAuthUtil.getAndClearTargetRoute();

    if (targetRoute != null) {
      // 有目标页面：跳转到目标页面（清除历史栈）
      String routeName = targetRoute['routeName'];
      Object? arguments = targetRoute['arguments'];
      if (routeName == "cardBaseMainPage") {
        Navigator.pushNamedAndRemoveUntil(
            ctx.context, 'cardBaseMainPage', (route) => false,
            arguments: {'userInfo': userInfo});

        AppsflyerSdk(null).logEvent(
            'login_to_main_page', {'id': userInfo.customer!.customerCode});
      } else {
        await Navigator.pushNamed(
          ctx.context,
          routeName,
          arguments: arguments,
        );
      }

      // 登录成功后返回结果给上一级
      // Navigator.pop(ctx.context, true);
    } else {
      // 无目标页面：跳转到默认的cardBaseMainPage
      Navigator.pushNamedAndRemoveUntil(
        ctx.context,
        'cardBaseMainPage',
        (route) => false,
        arguments: {'userInfo': userInfo},
      );

      AppsflyerSdk(null).logEvent(
          'login_to_main_page', {'id': userInfo.customer!.customerCode});
    }
  } else {
    print('error :${result.message}');
    // showToast(result.message, position: ToastPosition(offset: 150));
    // pr.hide();
  }
}
