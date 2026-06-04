import 'dart:io';
import 'dart:convert';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/login_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../cache/bean/user_info_bean.dart';
import '../../../cache/local_storage.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../http/result_data.dart';
import '../../bean/country_register_info.dart';
import '../../bean/login_bean.dart';
import 'action.dart';
import 'state.dart';

const String _multipleLoginMethodCacheKey = 'multiple_login_method_cache_v1';
const String _multipleLoginCountryCacheKey = 'multiple_login_country_cache_v1';

Effect<MultipleLoginState>? buildEffect() {
  return combineEffects(<Object, Effect<MultipleLoginState>>{
    // MultipleLoginAction.jump: _onAction,
    Lifecycle.initState: _onInit,
    MultipleLoginAction.emailLogin: _onEmailLogin,
    MultipleLoginAction.phoneLogin: _onPhoneLogin,
    MultipleLoginAction.register: _onRegister,
    MultipleLoginAction.loginTypeClick: _onLoginTypeClick,
    MultipleLoginAction.scanLogin: _onScanLogin,
    MultipleLoginAction.faceLogin: _faceLogin,
  });
}

Future<void> _onRegister(Action action, Context<MultipleLoginState> ctx) async {
  var result =
      await Navigator.of(ctx.context).pushReplacementNamed('registerPage');
  print('register result: $result');
  if (result != null) {
    Map<String, dynamic> loginMap = result as Map<String, dynamic>;
    String phoneNum = loginMap['phoneNum'];
    String password = loginMap['password'];
    _login(ctx, 'MOBILE', '86$phoneNum', password);
  }
}

Future<void> _onLoginTypeClick(
    Action action, Context<MultipleLoginState> ctx) async {
  // NFC_TOUCH
  var loginMethod = action.payload as LoginMethod;
  print('login type click: ${loginMethod.code}');
  if (loginMethod.code == 'NFC_TOUCH') {
    ctx.dispatch(MultipleLoginActionCreator.onScanLogin());
  } else if (loginMethod.code == 'FACE_ID_BIOMETRICS') {
    ctx.dispatch(MultipleLoginActionCreator.onFaceLogin());
  } else {
    final index = ctx.state.loginMethodList
        .indexWhere((element) => element.code == loginMethod.code);
    ctx.dispatch(MultipleLoginActionCreator.onUpdateLoginType(index));
  }
}

Future<void> _onScanLogin(
    Action action, Context<MultipleLoginState> ctx) async {
  // BaseCardInfo? cardInfo;
  // try{
  //   cardInfo = await CardUtil.scanPostCard(ctx.context);
  // }catch(error){
  //   showToast(error.toString());
  //   return;
  // }
  //
  // if(cardInfo == null){
  //   return;
  // }
  //
  // String imei = await PlatformDeviceId.getDeviceId ?? '';
  //
  // String identifier = cardInfo.identifier??'';
  //
  // var params = {
  //   "identifierCarrier": "NFC",
  //   "identityType": "TOUCH",
  //   "identifier": identifier,
  //   "imei": imei
  // };
  //
  // ProgressDialog pr = ProgressDialog(ctx.context);
  // await pr.show();
  // var resultData = await HttpManager.getInstance()
  //     .post(Address.loginMultipleUrl, null, data: params);
  // pr.hide();
  // if (resultData.isSuccess) {
  //   var userInfo = UserInfo.fromJson(resultData.data);
  //   LocalStorage.saveUserInfo(userInfo);
  //   Navigator.pushNamedAndRemoveUntil(
  //       ctx.context, 'mainPage', (route) => false,
  //       arguments: {'userInfo': userInfo});
  // } else {
  //   if (resultData.data != null) {
  //     var data = resultData.data['data'];
  //     String? phoneNum;
  //     if (data != null) {
  //       phoneNum = data['phone'];
  //       Navigator.of(ctx.context)
  //           .pushNamed('loginVerifyPage', arguments: {
  //         'identifier': identifier,
  //         'phoneNum': phoneNum,
  //         'cardNum': cardInfo.cardNum,
  //         'amount': cardInfo.amount
  //       });
  //     } else {
  //       Navigator.of(ctx.context).pushNamed('bindPhonePage',
  //           arguments: {
  //             'identifier': identifier,
  //             'cardInfo': cardInfo
  //           });
  //     }
  //   } else {
  //     showToast(resultData.message);
  //   }
  // }
}

Future<void> _onInit(Action action, Context<MultipleLoginState> ctx) async {
  await restoreMultipleLoginCache(ctx.state, (loginMethods, countries) {
    ctx.state.loginMethodList = loginMethods;
    ctx.state.countryList = countries;
    if (loginMethods.isNotEmpty) {
      ctx.dispatch(MultipleLoginActionCreator.onLoadSuccess(loginMethods));
    }
  });

  final countryFuture =
      HttpManager.getInstance().get(NetworkAddress.countryUrl);
  final loginMethodFuture =
      HttpManager.getInstance().get(NetworkAddress.loginMethodUrl);

  final countryResult = await countryFuture;
  if (countryResult.isSuccess) {
    final countryList = _parseCountryList(countryResult.data);
    if (countryList.isNotEmpty) {
      ctx.state.countryList = countryList;
      await LocalStorage.saveString(_multipleLoginCountryCacheKey,
          json.encode(countryList.map((e) => e.toJson()).toList()));
    }
  } else {
    print('multiple_login country load failed: ${countryResult.message}');
  }

  final result = await loginMethodFuture;
  if (result.isSuccess) {
    final loginMethodList = _parseLoginMethodList(result.data);
    if (loginMethodList.isNotEmpty) {
      ctx.state.loginMethodList = loginMethodList;
      ctx.dispatch(MultipleLoginActionCreator.onLoadSuccess(loginMethodList));
      await LocalStorage.saveString(_multipleLoginMethodCacheKey,
          json.encode(loginMethodList.map((e) => e.toJson()).toList()));
      return;
    }
  } else {
    print('multiple_login method load failed: ${result.message}');
  }

  // 首次加载失败（解密未就绪或网络抖动）且缓存为空时，静默重试一次
  // EncryptionManager 已在 onRequest 中触发了重试，这里再发一次请求
  // 注意：HttpManager.get() 内置了一次自动重试，此处用 autoRetry:false 避免叠加
  if (ctx.state.loginMethodList.isEmpty) {
    print('[multiple_login] first attempt failed/empty, retrying silently...');
    final retryResult = await HttpManager.getInstance()
        .get(NetworkAddress.loginMethodUrl, autoRetry: false);
    if (retryResult.isSuccess) {
      final retryList = _parseLoginMethodList(retryResult.data);
      if (retryList.isNotEmpty) {
        ctx.state.loginMethodList = retryList;
        ctx.dispatch(MultipleLoginActionCreator.onLoadSuccess(retryList));
        await LocalStorage.saveString(_multipleLoginMethodCacheKey,
            json.encode(retryList.map((e) => e.toJson()).toList()));
        return;
      }
    }
    // 重试仍然失败，才显示错误页
    print('[multiple_login] retry also failed, dispatching loadFailure');
    ctx.dispatch(MultipleLoginActionCreator.onLoadFailure(retryResult.message));
  }
}

List<CountryRegisterInfo> _parseCountryList(dynamic data) {
  if (data is List<dynamic>) {
    return data.map((e) => CountryRegisterInfo.fromJson(e)).toList();
  }
  return [];
}

List<LoginMethod> _parseLoginMethodList(dynamic data) {
  if (data is List<dynamic>) {
    final loginMethodList = data.map((e) => LoginMethod.fromJson(e)).toList();
    loginMethodList.retainWhere((element) => element.status == 'ACTIVE');
    loginMethodList.sort((a, b) => (a.seq ?? 0).compareTo(b.seq ?? 0));
    return loginMethodList;
  }
  return [];
}

void _onEmailLogin(Action action, Context<MultipleLoginState> ctx) {
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  String emailAddress = ctx.state.emailController.text;
  String password = ctx.state.emailPwdController.text;
  if (emailAddress.isEmpty) {
    showToast(ctx.state.languageResource!.enterEmail);
    return;
  }

  if (password.isEmpty) {
    showToast(ctx.state.languageResource!.enterPwd);
    return;
  }
  _login(ctx, 'EMAIL', emailAddress, password);
}

Future<void> _onPhoneLogin(
    Action action, Context<MultipleLoginState> ctx) async {
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  String phoneNum = ctx.state.phoneController.text;
  String password = ctx.state.phonePwdController.text;
  if (phoneNum.isEmpty) {
    showToast(ctx.state.languageResource!.enterPhoneNo,
        position: const ToastPosition(offset: 150));
    return;
  }

  if (password.isEmpty) {
    showToast(ctx.state.languageResource!.enterPwd,
        position: const ToastPosition(offset: 150));
    return;
  }

  _login(ctx, 'MOBILE', phoneNum, password);
}

Future<void> _login(
  Context<MultipleLoginState> ctx,
  String accountType,
  String account,
  String credential,
) async {
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
    "credential": credential,
    "identifierCarrier": accountType,
    "identityType": "PASSWORD",
    "isoCode": '86',
    "identifier": account,
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
    Navigator.pushNamedAndRemoveUntil(
        ctx.context, 'cardBaseMainPage', (route) => false,
        arguments: {'userInfo': userInfo});
  } else {
    print('error :${result.message}');
    showToast(result.message, position: const ToastPosition(offset: 150));
  }
}

Future<void> _faceLogin(Action action, Context<MultipleLoginState> ctx) async {
  final LocalAuthentication auth = LocalAuthentication();

  // step 2: Face ID / 指纹认证
  final canAuth = await auth.canCheckBiometrics;
  if (!canAuth) {
    print("设备不支持生物识别");
    showToast("Device does not support biometrics",
        position: const ToastPosition(offset: 150));
  }

  var storage = const FlutterSecureStorage();
  // var isBiometricEnabled = await storage.read(key: 'isBiometricEnabled');
  // if (isBiometricEnabled != '1') {
  //   showToast("Biometrics not set up", position: ToastPosition(offset: 150));
  //   return;
  // }
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

  final deviceId = await storage.read(key: 'device_id');
  if (deviceId == null || deviceId.isEmpty) {
    showToast("Face ID not set up", position: const ToastPosition(offset: 150));
    pr.hide();
    return;
  }
  final publickey = await BlockchainPlatform.instance.generateKey();
  final credential = await _loginWithFace(ctx);
  var params = {
    "credential": credential,
    "identifierCarrier": Platform.isAndroid ? 'TOUCH_ID' : 'FACE_ID',
    "identityType": "BIOMETRICS",
    "identifier": deviceId,
    'platform': Platform.isAndroid ? 'android' : 'ios',
    'deviceId': deviceId,
    'deviceName': deviceName,
    'versionCode': versionCode,
    'versionName': versionName,
    'code': publickey
  };

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.loginMultipleUrl, null, data: params);

  pr.hide();
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

      Navigator.pushNamedAndRemoveUntil(
        ctx.context,
        routeName,
        (route) => false,
        arguments: arguments,
      );
      // 登录成功后返回结果给上一级
      Navigator.pop(ctx.context, true);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          ctx.context, 'cardBaseMainPage', (route) => false,
          arguments: {'userInfo': userInfo});
    }
  } else {
    print('error :${result.message}');
    showToast(result.message, position: const ToastPosition(offset: 150));
  }
}

Future<String> _loginWithFace(Context<MultipleLoginState> ctx) async {
  var storage = const FlutterSecureStorage();

  final deviceId = await storage.read(key: 'device_id');

  try {
    // step 1: 模拟从服务器获取 challenge
    ResultData result = await HttpManager.getInstance()
        .post(NetworkAddress.loginChallenge, null, data: {
      'deviceId': deviceId,
      'challengeType': Platform.isAndroid ? 'TOUCH_ID' : 'FACE_ID'
    });
    final challenge = result.data['challenge'];
    print("🪪 获取 challenge: $challenge");

    // // step 2: Face ID / 指纹认证
    // final canAuth = await auth.canCheckBiometrics;
    // if (!canAuth) {
    //   print("设备不支持生物识别");
    //   return '';
    // }

    // final ok = await auth.authenticate(
    //   localizedReason: "请进行 Face ID 验证",
    //   options: const AuthenticationOptions(biometricOnly: true),
    // );
    // if (!ok) {
    //   print("Face ID 验证失败");
    //   return '';
    // }

    // step 3: 调用原生 Secure Enclave / Keystore 签名
    var signature = await BlockchainPlatform.instance.signChallenge(challenge);

    print("✅ 签名成功，signature:$signature");
    return signature;
    // print("服务器返回: ${response.statusCode}");
  } catch (error) {
    print("sign-error:$error");
    return '';
  }
}
