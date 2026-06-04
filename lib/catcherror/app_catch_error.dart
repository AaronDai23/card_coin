import 'dart:async';

import 'package:card_coin/observability/otel_service.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//全局异常的捕捉

class AppCatchError {
  run(Widget app) {
    // Flutter 框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      // 线上环境

      // MethodManager.invokeCatchedException(map);
      await BlockchainPlatform.instance
          .postCatchedException("33333message:${details.stack}");
      OtelService.instance.recordGlobalException(
        'flutter_error',
        details.exception,
        details.stack ?? StackTrace.current,
      );

      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        // 开发期间 print
        FlutterError.dumpErrorToConsole(details);
      }

      // if (EasyLoading.isShow) {

      //   EasyLoading.dismiss();

      // }

      // logger.e(details.toString());
      // LogUtil.e(details.toString());
    };

    // 注意：WidgetsFlutterBinding.ensureInitialized() 已在 mainCommon 中执行。
    // 此处若再切换到新 Zone 调用 runApp，会触发 Flutter 的 Zone mismatch 断言。
    StartupTime.mark('appcatcherror_before_runapp');
    runApp(app);
    StartupTime.mark('appcatcherror_after_runapp');
  }

  ///对搜集的 异常进行处理  上报等等

  catchError(Object error, StackTrace stack) {
    LogUtil.e('错误 message:$error,stack: $stack');

    String errorStr =
        "Unhandled Exception:$error########################### stack$stack";
    // 此处为 flutter 与原生交互 将 error 传给原生
    // MethodManager.invokeCatchedException(map);
    BlockchainPlatform.instance.postCatchedException(errorStr);
    OtelService.instance.recordGlobalException('zoned_guarded', error, stack);
  }
}
