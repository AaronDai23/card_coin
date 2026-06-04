import 'dart:async';
import 'dart:ui';

import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/catcherror/app_catch_error.dart';
import 'package:card_coin/observability/otel_service.dart';
import 'package:card_coin/resource/display_strings_main_google_lite.dart';
import 'package:card_coin/widget/app_config.dart';
import 'app.dart';

///执行命令运行项目
/// flutter run --flavor card_coin_google -t lib/main_google.dart
///打包
/// flutter build apk --flavor card_coin_google -t lib/main_google.dart --release
/// flutter build appbundle --flavor card_coin_google -t lib/main_google.dart
Future<void> main() async {
  // _sharetraceHandle();
  var configuredApp = AppConfig(
    appDisplayName: "ChipBase",
    appInternalId: AppType.googleLite,
    stringResource: StringResourceMainGoogleLite(),
    child: const MyApp(),
  );
  await mainCommon();
  await OtelService.instance.init();

  PlatformDispatcher.instance.onError = (error, stack) {
    OtelService.instance.recordGlobalException(
      'platform_dispatcher',
      error,
      stack,
    );
    return false;
  };

  LogUtils.init();
  AppCatchError().run(configuredApp);
}
