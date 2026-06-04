import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/global_store/action.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:card_coin/utils/deep_link_manager.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../http/result_data.dart';
import '../../cache/local_storage.dart';
import '../../http/address.dart';
import '../../http/http_manager.dart';
import '../../widget/app_config.dart';
import 'action.dart';
import 'state.dart';
import 'package:collection/collection.dart';

Effect<SplashState>? buildEffect() {
  return combineEffects(<Object, Effect<SplashState>>{
    Lifecycle.initState: _onInit,
    SplashAction.startAppsFlyer: _onStartAppsFlyer,
    SplashAction.register: _onRegister,
  });
}

Future<void> _onInit(Action action, Context<SplashState> ctx) async {
  StartupTime.printElapsed('splash_on_init_begin');
  // 1. 优先使用本地缓存初始化国际化，避免冷启动被网络请求阻塞
  await _initLocalizationFromCache();
  StartupTime.printElapsed('splash_localization_cache_ready');

  // 2. 远端国际化后台刷新，不阻塞首屏进入
  unawaited(_refreshLocalizationFromServer());

  // 3. 初始化全局 DeepLink 监听（仅调用一次）
  DeepLinkManager().init();
  StartupTime.printElapsed('splash_before_start_appsflyer');
  ctx.dispatch(SplashActionCreator.onStartAppsFlyer());
}

Future<void> _initLocalizationFromCache() async {
  late final Map<String, dynamic> localizationMessages;
  var localizationList = await LocalStorage.getString('localizationList');
  if (localizationList == null) {
    localizationMessages = <String, dynamic>{};
  } else {
    try {
      localizationMessages = json.decode(localizationList);
    } catch (_) {
      localizationMessages = <String, dynamic>{};
    }
  }

  if (localizationMessages.isEmpty) {
    return;
  }

  // 默认英文
  var localeStr = localizationMessages.keys
      .firstWhereOrNull((element) => element == 'en_US');
  Locale locale;
  if (localeStr != null) {
    locale = StringUtils.string2Locale(localeStr);
  } else {
    localeStr = localizationMessages.keys.first;
    locale = StringUtils.string2Locale(localeStr);
  }

  GlobalStore.store
      .dispatch(GlobalActionCreator.onInitLocalization(localizationMessages));
  LocalStorage.saveLocale(locale);
  GlobalStore.store.dispatch(GlobalActionCreator.onChangeLanguage(locale));
}

Future<void> _refreshLocalizationFromServer() async {
  try {
    ResultData localizationResult = await HttpManager.getInstance()
        .get(NetworkAddress.localeMessageMd5Url)
        .timeout(const Duration(seconds: 2));
    String lastMd5 = '';
    if (localizationResult.isSuccess) {
      lastMd5 = localizationResult.data ?? '';
    }
    var localMd5 = await LocalStorage.getString('localization_md5');
    if (lastMd5.isEmpty || lastMd5 == localMd5) {
      return;
    }

    ResultData localizationListResult = await HttpManager.getInstance()
        .get(NetworkAddress.localeMessageListUrl)
        .timeout(const Duration(seconds: 3));
    if (!localizationListResult.isSuccess ||
        localizationListResult.data is String) {
      return;
    }

    Map<String, dynamic> localizationMessages = localizationListResult.data;

    ///由于服务器构建多语言时印尼语code填写错误，需要客户端把 in_ID 更正为 id_ID
    var inIDLocale = localizationMessages.keys
        .firstWhereOrNull((element) => element == 'in_ID');
    if (inIDLocale != null) {
      localizationMessages['id_ID'] = localizationMessages['in_ID'];
      localizationMessages.remove('in_ID');
    }

    await LocalStorage.saveString('localization_md5', lastMd5);
    await LocalStorage.saveString(
        'localizationList', json.encode(localizationMessages));

    // 后台更新完成后同步刷新全局文案
    GlobalStore.store
        .dispatch(GlobalActionCreator.onInitLocalization(localizationMessages));
  } catch (_) {
    // 网络波动下忽略刷新失败，避免影响冷启动流程
  }
}

void _onStartAppsFlyer(Action action, Context<SplashState> ctx) async {
  StartupTime.printElapsed('appsflyer_init_begin');
  // SDK Options
  final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: dotenv.env["DEV_KEY"]!,
      appId: dotenv.env["APP_ID"]!,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 15,
      manualStart: true);
  /*
    final Map? map = {
      'afDevKey': dotenv.env["DEV_KEY"]!,
      'appId': dotenv.env["APP_ID"]!,
      'isDebug': true,
      'timeToWaitForATTUserAuthorization': 15.0//,
      //'manualStart': false
    };
    _appsflyerSdk = AppsflyerSdk(map);
     */
  var appsflyerSdk = AppsflyerSdk(options);

  /*
    Setting configuration to the SDK:
    _appsflyerSdk.setCurrencyCode("USD");
    _appsflyerSdk.enableTCFDataCollection(true);
    var forGdpr = AppsFlyerConsent.forGDPRUser(hasConsentForDataUsage: true, hasConsentForAdsPersonalization: true);
    _appsflyerSdk.setConsentData(forGdpr);
    var nonGdpr = AppsFlyerConsent.nonGDPRUser();
    _appsflyerSdk.setConsentData(nonGdpr);
     */

  // Init of AppsFlyer SDK（后台执行，不阻塞冷启动进入主流程）
  unawaited(appsflyerSdk
      .initSdk(
    registerConversionDataCallback: true,
    registerOnAppOpenAttributionCallback: true,
    registerOnDeepLinkingCallback: true,
  )
      .then((_) {
    StartupTime.printElapsed('appsflyer_init_done');
  }).catchError((e) {
    print('appsflyer initSdk failed: $e');
  }));

  // Conversion data callback
  appsflyerSdk.onInstallConversionData((res) {
    print("onInstallConversionData res: $res");
    //  showToast("onInstallConversionData res: " + res.toString());
  });

  // App open attribution callback
  appsflyerSdk.onAppOpenAttribution((res) {
    print("onAppOpenAttribution res: $res");
  });

  // Deep linking callback
  appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
    // showToast("appflyer_onDeepLinking res: " + dp.toString());
    switch (dp.status) {
      case Status.FOUND:
        print("dp.deepLink?.toString():${dp.deepLink?.toString()}");
        if (dp.deepLink != null) {
          print("deep link found: ${dp.deepLink}");
        }
        var map = dp.deepLink?.clickEvent;

        if (map != null) {
          if (map['scheme'] == "st944a9eb04e40fdbc") {
            ctx.dispatch(SplashActionCreator.onRegister(map));
          }
          print("deep link map: $map");

          // showToast("deep link map: $map");
        }

        // Map map = dp.deepLink as Map;
        // print("deep link map: $map");
        // ctx.dispatch(SplashActionCreator.onRegister(map));
        // print("deep link value: ${dp.deepLink?.deepLinkValue}");
        break;
      case Status.NOT_FOUND:
        print("deep link not found");
        break;
      case Status.ERROR:
        print("deep link error: ${dp.error}");
        break;
      case Status.PARSE_ERROR:
        print("deep link status parsing error");
        break;
    }

    print("'res222: $dp");
  });

  // appsflyerSdk.onAppOpenAttribution((res) {
  //   print("onAppOpenAttribution res: " + res.toString());
  //   // 延迟1秒
  //   showToast("onAppOpenAtt442ribution res: " + res.toString());
  // });

  // appsflyerSdk.anonymizeUser(true);
  if (Platform.isAndroid) {
    appsflyerSdk.performOnDeepLinking();
  }

  void gotoMainPage() async {
    StartupTime.printElapsed('goto_main_page_begin');
    var appId = AppConfig.of(ctx.context).appInternalId;
    if (appId == AppType.lite || appId == AppType.pro) {
      Navigator.pushNamedAndRemoveUntil(
          ctx.context, 'mainPage', (route) => false);
    } else {
      var userInfo = await LocalStorage.getUserInfo();
      if (userInfo != null) {
        Navigator.pushNamedAndRemoveUntil(
            ctx.context, 'cardBaseMainPage', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            ctx.context, 'scanLoginPage', (route) => false);
      }
    }
  }

  // GooglePlayServicesAvailability availability = await GoogleApiAvailability
  //     .instance
  //     .checkGooglePlayServicesAvailability();
  // if (availability == GooglePlayServicesAvailability.success) {
  //   final completer = Completer();

  //   appsflyerSdk.startSDK(
  //     onSuccess: () async {
  //       print("AppsFlyer SDK initialized successfully.");
  //       completer.complete();
  //     },
  //     onError: (int errorCode, String errorMessage) {
  //       print("Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
  //       completer.complete();
  //     },
  //   );

  //   await completer.future.timeout(Duration(seconds: 5),onTimeout: () => gotoMainPage());
  //   gotoMainPage();
  // } else {
  gotoMainPage();
  // }
}

Future<void> _login(
  Context<SplashState> ctx,
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

Future<void> _onRegister(Action action, Context<SplashState> ctx) async {
  print('register payload: ${action.payload}');
  var map = action.payload as Map<String, dynamic>;
  var link = map['link'];
  final uri = Uri.parse(link);

// 所有 query 参数
  final params = uri.queryParameters;

// 单独取值
  final target = params['target'] ?? "";
  final uid = params['uid'];
  final taskItemId = params['taskItemId'];
  Map<String, String> arguments;
  if (uid != null && taskItemId != null) {
    arguments = {'uid': uid, 'taskItemId': taskItemId};
    HttpManager.getInstance().post(NetworkAddress.taskItemCompleted, null,
        data: {'uid': uid, 'taskItemId': taskItemId});
    // if (reslut.isSuccess) {
    //   print('任务完成上报成功');
    // } else {
    //   print('任务完成上报失败: ${reslut.message}');
    // }
    if (target == "registerPage") {
      var result1 = await Navigator.of(ctx.context)
          .pushNamed(target, arguments: arguments);
      print('register result: $result1');
      if (result1 != null) {
        Map<String, dynamic> loginMap = result1 as Map<String, dynamic>;
        String phoneNum = loginMap['phoneNum'];
        String password = loginMap['password'];
        _login(ctx, 'MOBILE', '86$phoneNum', password);
      }
    } else {
      var result21 = await Navigator.of(ctx.context)
          .pushNamed(target, arguments: arguments);
      print('splash_target result: $result21');
    }
  }
}
