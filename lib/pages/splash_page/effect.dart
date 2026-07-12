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
import 'package:card_coin/app.dart' show navigatorKey;
import 'package:card_coin/utils/string_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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

/// 顶层函数：在后台 isolate 解析多语言 JSON，只返回当前语言数据。
/// 旧做法：返回全部语言 Map（50+ 语言），从 isolate 传回主线程时需反序列化
/// 50,000+ 个 Dart 对象，阻塞事件循环 ~20 秒。
/// 新做法：只返回 1 个语言的数据，传输量缩小 50 倍，阻塞 < 0.5 秒。
/// args[0] = JSON 字符串，args[1] = 目标 locale key（如 'en_US'）
Map<String, dynamic> _extractSingleLocale(List<dynamic> args) {
  final jsonStr = args[0] as String;
  final wantedKey = args[1] as String;
  try {
    final all = json.decode(jsonStr) as Map<String, dynamic>;
    final key = all.containsKey(wantedKey)
        ? wantedKey
        : (all.containsKey('en_US')
            ? 'en_US'
            : (all.keys.isNotEmpty ? all.keys.first : null));
    if (key == null) return {};
    final data = all[key];
    return {key: data is Map<String, dynamic> ? data : {}};
  } catch (_) {
    return {};
  }
}

Effect<SplashState>? buildEffect() {
  return combineEffects(<Object, Effect<SplashState>>{
    Lifecycle.initState: _onInit,
    SplashAction.startAppsFlyer: _onStartAppsFlyer,
    SplashAction.register: _onRegister,
  });
}

Future<void> _onInit(Action action, Context<SplashState> ctx) async {
  final _t0 = DateTime.now().millisecondsSinceEpoch;
  debugPrint('[TIMING][Splash] _onInit start, t=$_t0');
  StartupTime.printElapsed('splash_on_init_begin');

  // 3. 初始化全局 DeepLink 监听（仅调用一次）
  DeepLinkManager().init();
  debugPrint(
      '[TIMING][Splash] DeepLinkManager.init() dispatched, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');

  // 多语言缓存：完全异步，不阻塞导航流程。
  // 注意：不使用 await，因为大型 JSON（>200KB）的 compute() 会阻塞 isolate
  // 通信通道数十秒；即使走 200KB 分支也不应阻塞首屏导航。
  unawaited(_initLocalizationFromCache());

  // 远端国际化后台刷新，不阻塞首屏进入
  unawaited(_refreshLocalizationFromServer());

  // AppConfig.of(context) 是 InheritedWidget，必须在 initState() 完成后才能访问。
  await Future<void>.delayed(Duration.zero);
  debugPrint(
      '[TIMING][Splash] after delayed(zero), dispatching onStartAppsFlyer, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
  StartupTime.printElapsed('splash_before_start_appsflyer');
  ctx.dispatch(SplashActionCreator.onStartAppsFlyer());
  debugPrint(
      '[TIMING][Splash] onStartAppsFlyer dispatched, t=${DateTime.now().millisecondsSinceEpoch - _t0}ms');
}

Future<void> _initLocalizationFromCache() async {
  late final Map<String, dynamic> localizationMessages;
  var localizationList = await LocalStorage.getString('localizationList');
  if (localizationList == null) {
    localizationMessages = <String, dynamic>{};
  } else if (localizationList.length > 200000) {
    // JSON 超过 200KB：即使只提取 1 个语言，background isolate 里
    // json.decode() 整个字符串也需要 10-20 秒。
    // 直接跳过，由 _refreshLocalizationFromServer() 在后台刷新。
    print(
        '[i18n] localizationList too large (${localizationList.length} bytes), skip cache');
    return;
  } else {
    try {
      // 只提取当前语言的数据（1 个语言 vs 全部 50+ 语言）
      final currentLocale = GlobalStore.store.getState().languageLocale;
      final localeKey = currentLocale != null
          ? '${currentLocale.languageCode}_${currentLocale.countryCode}'
          : 'en_US';
      localizationMessages =
          await compute(_extractSingleLocale, [localizationList, localeKey]);
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
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => ResultData(false, -1, 'timeout'),
        );
    String lastMd5 = '';
    if (localizationResult.isSuccess) {
      lastMd5 = localizationResult.data ?? '';
    }
    var localMd5 = await LocalStorage.getString('localization_md5');
    print('[i18n] lastMd5=$lastMd5 localMd5=$localMd5');
    if (lastMd5.isEmpty || lastMd5 == localMd5) {
      print(
          '[i18n] skip fetch: lastMd5.isEmpty=${lastMd5.isEmpty} same=${lastMd5 == localMd5}');
      return;
    }

    ResultData localizationListResult = await HttpManager.getInstance()
        .get(NetworkAddress.localeMessageListUrl)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => ResultData(false, -1, 'timeout'),
        );
    if (!localizationListResult.isSuccess) {
      return;
    }

    Map<String, dynamic> localizationMessages;
    if (localizationListResult.data is String) {
      try {
        localizationMessages = json.decode(localizationListResult.data);
      } catch (_) {
        return;
      }
    } else {
      localizationMessages = localizationListResult.data;
    }

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
  } catch (e, s) {
    // 网络波动下忽略刷新失败，避免影响冷启动流程
    print('[i18n] _refreshLocalizationFromServer error: $e\n$s');
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
    final _gt0 = DateTime.now().millisecondsSinceEpoch;
    print('[TIMING][Splash] gotoMainPage start, t=$_gt0');
    StartupTime.printElapsed('goto_main_page_begin');

    // DeepLink 冷启动保护：若 DeepLinkManager 已将用户导航到真实页面，
    // SplashPage 的 gotoMainPage 不应再清栈，否则会把 DeepLink 推入的页面清掉。
    // 约定：栈顶为 splashPage 路由名('/')、骨架屏('_deepLinkLoading')或 null
    // 时才允许正常导航；其他情况说明 DeepLink 已占据导航主导权，直接 return。
    final _routes = <String>{
      'cardBaseMainPage',
      'scanLoginPage',
      'mainPage',
      'multipleLoginPage',
      '/',
      'splashPage',
      '_deepLinkLoading',
    };
    String? currentTop;
    navigatorKey.currentState?.popUntil((route) {
      currentTop = route.settings.name;
      return true;
    });
    if (currentTop != null && !_routes.contains(currentTop)) {
      print(
          '[TIMING][Splash] gotoMainPage: SKIP, DeepLink already navigated to $currentTop');
      return;
    }

    var appId = AppConfig.of(ctx.context).appInternalId;
    if (appId == AppType.lite || appId == AppType.pro) {
      print(
          '[TIMING][Splash] navigating to mainPage, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
      Navigator.pushNamedAndRemoveUntil(
          ctx.context, 'mainPage', (route) => false);
    } else {
      print(
          '[TIMING][Splash] calling getUserInfo, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
      var userInfo = await LocalStorage.getUserInfo();
      print(
          '[TIMING][Splash] getUserInfo done, userInfo=${userInfo != null ? "exists" : "null"}, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
      if (userInfo != null) {
        print(
            '[TIMING][Splash] navigating to cardBaseMainPage, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
        Navigator.pushNamedAndRemoveUntil(
            ctx.context, 'cardBaseMainPage', (route) => false);
      } else {
        print(
            '[TIMING][Splash] navigating to scanLoginPage, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
        Navigator.pushNamedAndRemoveUntil(
            ctx.context, 'scanLoginPage', (route) => false);
      }
    }
    print(
        '[TIMING][Splash] gotoMainPage complete, t=${DateTime.now().millisecondsSinceEpoch - _gt0}ms');
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
