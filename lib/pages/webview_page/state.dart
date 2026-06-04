import 'dart:async';

import 'package:webview_flutter/webview_flutter.dart';

import '../../widget/base_page_loading.dart';

class WebviewState extends LoadPageState<WebviewState> {
  String? pageUrl;
  late String title;
  String? callback;
  double progress = 0.0;
  int lastProgressPercent = 0;
  bool showProgress = false;
  WebViewController? controller;
  Timer? pageLoadTimeoutTimer;
  // 进度停滞计时器：onProgress 停止触发超过 4 秒（JS 执行阶段）时静默隐藏进度条。
  Timer? progressStallTimer;
  // 页面加载计时将各阶段耗时打印到日志，区分「网络下载慢」和「JS 执行慢」。
  DateTime? pageLoadStartTime;

  List<String> blackList = [];

  bool showForward = false;

  String? cardId;
  @override
  WebviewState clone() {
    return WebviewState()
      ..pageUrl = pageUrl
      ..title = title
      ..progress = progress
      ..lastProgressPercent = lastProgressPercent
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..showProgress = showProgress
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..blackList = blackList
      ..callback = callback
      ..controller = controller
      ..pageLoadTimeoutTimer = pageLoadTimeoutTimer
      ..progressStallTimer = progressStallTimer
      ..pageLoadStartTime = pageLoadStartTime
      ..showForward = showForward
      ..cardId = cardId;
  }
}

WebviewState initState(Map<String, dynamic>? args) {
  String? pageUrl = args?['pageUrl'];
  String title = args?['title'] ?? '';
  String? callback = args?['callback'];
  bool showForward = args?['showForward'] ?? false;

  return WebviewState()
    ..pageUrl = pageUrl
    ..callback = callback
    ..showForward = showForward
    ..loadStatus = LoadType.loadSuccess
    ..title = title;
}
