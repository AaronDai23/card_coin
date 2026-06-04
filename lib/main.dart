import 'dart:async';
import 'dart:ui';

import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/catcherror/app_catch_error.dart';
import 'package:card_coin/observability/otel_service.dart';
import 'package:card_coin/resource/display_strings_main.dart';
import 'package:card_coin/resource/display_strings_main_pro.dart';
// import 'package:card_coin/resource/display_strings_main_google_lite.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:flutter/material.dart';
import 'app.dart';
// import 'package:network_capture/network_capture.dart';
// import 'package:flutter_bugly/flutter_bugly.dart';

final navGK = GlobalKey<NavigatorState>();

///执行命令运行项目
/// flutter run --flavor card_coin -t lib/main.dart
///打包
/// flutter build apk --flavor card_coin -t lib/main.dart
Future<void> main() async {
  var configuredApp = AppConfig(
    appDisplayName: "ChipBase",
    appInternalId: AppType.googleLite,
    stringResource: StringResourceMainPro(),
    child: const MyApp(),
  );

  StartupTime.mark('main_before_maincommon');
  await mainCommon();
  StartupTime.mark('main_after_maincommon');
  await OtelService.instance.init();

  PlatformDispatcher.instance.onError = (error, stack) {
    OtelService.instance.recordGlobalException(
      'platform_dispatcher',
      error,
      stack,
    );
    return false;
  };

  // FlutterBugly.postCatchedException(() {
  //   // 如果需要 ensureInitialized，请在这里运行。
  // WidgetsFlutterBinding.ensureInitialized();
  AppCatchError().run((configuredApp));
  LogUtils.init();
  // FlutterError.onError = (FlutterErrorDetails details) async {
  //   Zone.current.handleUncaughtError(details.exception, details.stack!);
  // };

  // runZoned<Future<void>>(() async {
  //   runApp(configuredApp);
  // }, onError: (error, stackTrace) async {
  //   await _reportError(error, stackTrace);
  // });

  // }, debugUpload: true);
}
