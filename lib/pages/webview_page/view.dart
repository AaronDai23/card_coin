import 'dart:async';
import 'dart:convert';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app.dart';
import '../../cache/local_storage.dart';
import '../../card_base/bean/start_page_info.dart';
import '../../reown_wallet/bottom_sheet/bottom_sheet_listener.dart';
import '../../reown_wallet/deep_link_handler.dart';
import '../../widget/base_page_loading.dart';
import '../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

const Duration _kWebPageLoadTimeout = Duration(seconds: 25);

String? _normalizeWebUrl(String? rawUrl) {
  if (rawUrl == null) return null;
  var value = rawUrl.trim();
  if (value.isEmpty) return null;

  if (value.startsWith('//')) {
    value = 'https:$value';
  }

  var uri = Uri.tryParse(value);
  if (uri == null) return null;

  if (!uri.hasScheme) {
    // 支持从后端返回 example.com/path 这类无 scheme 链接。
    value = 'https://$value';
    uri = Uri.tryParse(value);
  }

  if (uri == null) return null;
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'http' && scheme != 'https') {
    return null;
  }

  return uri.toString();
}

Widget buildView(
    WebviewState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(state.showForward ? Icons.close : Icons.arrow_back),
            onPressed: () => Navigator.of(viewService.context).pop(),
          ),
          title: Text(state.title),
          actions: state.showForward
              ? [
                  IconButton(
                      onPressed: () async {
                        var canBack =
                            (await state.controller?.canGoBack()) ?? false;
                        if (canBack) {
                          state.controller?.goBack();
                        }
                      },
                      icon: const Icon(Icons.arrow_back)),
                  IconButton(
                      onPressed: () async {
                        var canBack =
                            (await state.controller?.canGoForward()) ?? false;
                        if (canBack) {
                          state.controller?.goForward();
                        }
                      },
                      icon: const Icon(Icons.arrow_forward)),
                  IconButton(
                      onPressed: () => state.controller?.reload(),
                      icon: const Icon(Icons.refresh)),
                ]
              : []),
      body: BasePageLoadingView(
        errorMsg: state.errorMsg,
        loadStatus: state.loadStatus,
        onReload: () {
          dispatch(WebviewActionCreator.onShowLoading());
          dispatch(WebviewActionCreator.onLoadDomain());
        },
        buildBody: (isSuccess) {
          final pageUrl = _normalizeWebUrl(state.pageUrl);
          return isSuccess
              ? SafeArea(
                  child: BottomSheetListener(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Visibility(
                              visible: state.showProgress,
                              child: LinearProgressIndicator(
                                value: state.progress,
                                backgroundColor: Colors.white,
                                minHeight: 2,
                              ),
                            ),
                            Expanded(
                              child: pageUrl == null
                                  ? Center(
                                      child: Text(
                                        state.languageResource
                                                ?.linkFormatError ??
                                            'Invalid URL',
                                        style: const TextStyle(
                                            color: Colors.redAccent),
                                      ),
                                    )
                                  : WebView(
                                      // 页面渲染前保持白色背景，避免 SurfaceView
                                      // 或 TextureView 初始化期间露出黑色底色。
                                      backgroundColor: Colors.white,

                                      onWebViewCreated:
                                          (WebViewController controller) {
                                        state.controller = controller;
                                      },

                                      navigationDelegate:
                                          (NavigationRequest request) {
                                        final uri = Uri.tryParse(request.url);
                                        if (uri != null) {
                                          if (uri.scheme == 'wc') {
                                            dispatch(WebviewActionCreator
                                                .onParsedWalletUrl(uri));
                                            return NavigationDecision.prevent;
                                          }
                                        }
                                        return NavigationDecision.navigate;
                                      },

                                      onWebResourceError:
                                          (WebResourceError error) {
                                        state.pageLoadTimeoutTimer?.cancel();
                                        state.pageLoadTimeoutTimer = null;
                                        final failingUrl =
                                            error.failingUrl ?? '';
                                        final targetUrl = state.pageUrl ?? '';
                                        // 子资源失败（如图片/统计脚本）不弹窗，避免影响主页面加载体验。
                                        if (targetUrl.isNotEmpty &&
                                            failingUrl.isNotEmpty &&
                                            failingUrl != targetUrl) {
                                          // 子资源失败也记录日志以供分析。
                                          final subElapsed = state
                                                      .pageLoadStartTime !=
                                                  null
                                              ? DateTime.now()
                                                  .difference(
                                                      state.pageLoadStartTime!)
                                                  .inMilliseconds
                                              : -1;
                                          print(
                                              '[WebviewTiming] sub-resource error +${subElapsed}ms '
                                              'code=${error.errorCode} url=$failingUrl');
                                          return;
                                        }
                                        // 主页面加载失败时取消停滞计时器并隐藏进度条。
                                        state.progressStallTimer?.cancel();
                                        state.progressStallTimer = null;
                                        final mainErrElapsed = state
                                                    .pageLoadStartTime !=
                                                null
                                            ? DateTime.now()
                                                .difference(
                                                    state.pageLoadStartTime!)
                                                .inMilliseconds
                                            : -1;
                                        print(
                                            '[WebviewTiming] MAIN-PAGE error +${mainErrElapsed}ms '
                                            'code=${error.errorCode} desc=${error.description}');
                                        dispatch(WebviewActionCreator
                                            .onShowProgressIndicator(false));
                                        print(
                                            "WebResourceError:description:${error.description}, errorCode:${error.errorCode},failingUrl:${error.failingUrl}");
                                        showDialog(
                                            context: viewService.context,
                                            builder: (context) {
                                              return ZenggeTextAlertDialog(
                                                  error.description);
                                            });
                                      },

                                      onProgress: (int progress) {
                                        // 每次收到进度事件都重置停滞计时器。
                                        // 若 4 秒内再无事件（JS 正在执行），静默隐藏进度条。
                                        state.progressStallTimer?.cancel();
                                        if (progress < 100) {
                                          state.progressStallTimer = Timer(
                                              const Duration(seconds: 4), () {
                                            state.progressStallTimer = null;
                                            dispatch(WebviewActionCreator
                                                .onShowProgressIndicator(
                                                    false));
                                          });
                                        }
                                        // 每到 10% 节点打印一次时间截面。
                                        if (progress % 10 == 0 ||
                                            progress == 100) {
                                          final progElapsed = state
                                                      .pageLoadStartTime !=
                                                  null
                                              ? DateTime.now()
                                                  .difference(
                                                      state.pageLoadStartTime!)
                                                  .inMilliseconds
                                              : -1;
                                          print('[WebviewTiming] onProgress '
                                              '$progress% +${progElapsed}ms');
                                        }
                                        dispatch(WebviewActionCreator
                                            .onUpdateProgress(progress / 100));
                                      },

                                      onPageStarted: (url) {
                                        state.pageLoadStartTime =
                                            DateTime.now();
                                        print(
                                            '[WebviewTiming] onPageStarted url=$url');
                                        state.progressStallTimer?.cancel();
                                        state.progressStallTimer = null;
                                        state.pageLoadTimeoutTimer?.cancel();
                                        state.pageLoadTimeoutTimer =
                                            Timer(_kWebPageLoadTimeout, () {
                                          // 超时后静默隐藏进度条，页面继续后台加载。
                                          dispatch(WebviewActionCreator
                                              .onShowProgressIndicator(false));
                                        });
                                        dispatch(WebviewActionCreator
                                            .onUpdateProgress(0));
                                        dispatch(WebviewActionCreator
                                            .onShowProgressIndicator(true));
                                      },

                                      onPageFinished: (url) {
                                        final finishedElapsed = state
                                                    .pageLoadStartTime !=
                                                null
                                            ? DateTime.now()
                                                .difference(
                                                    state.pageLoadStartTime!)
                                                .inMilliseconds
                                            : -1;
                                        print(
                                            '[WebviewTiming] onPageFinished TOTAL +${finishedElapsed}ms url=$url');
                                        state.pageLoadStartTime = null;
                                        state.progressStallTimer?.cancel();
                                        state.progressStallTimer = null;
                                        state.pageLoadTimeoutTimer?.cancel();
                                        state.pageLoadTimeoutTimer = null;
                                        dispatch(WebviewActionCreator
                                            .onShowProgressIndicator(false));

                                        // 执行回调函数
                                        if (state.callback != null) {
                                          state.controller
                                              ?.runJavascript(state.callback!);
                                        }

                                        // 轻量修复：仅设置 html/body 滚动样式，避免全量遍历 DOM 造成卡顿。
                                        state.controller?.runJavascript('''
                                    (function() {
                                      var html = document.documentElement;
                                      var body = document.body;
                                      if (!html || !body) return;

                                      html.style.overflowY = 'auto';
                                      html.style.height = 'auto';
                                      html.style.webkitOverflowScrolling = 'touch';

                                      body.style.overflowY = 'auto';
                                      body.style.height = 'auto';
                                      body.style.webkitOverflowScrolling = 'touch';
                                      body.style.position = 'relative';
                                    })();
                                  ''');
                                      },

                                      // 启用缩放（如果需要）
                                      zoomEnabled: true,

                                      // 启用JavaScript（确保已设置）
                                      javascriptMode:
                                          JavascriptMode.unrestricted,

                                      initialUrl: pageUrl,

                                      javascriptChannels: {
                                        JavascriptChannel(
                                            name: 'injectedObject',
                                            onMessageReceived:
                                                (JavascriptMessage message) {
                                              var pageInfo =
                                                  StartPageInfo.fromJson(json
                                                      .decode(message.message));
                                              if (pageInfo.actionType ==
                                                  'ACTIVITY') {
                                                PageRoutes pageRoutes = AppRoute
                                                    .global as PageRoutes;
                                                var canPush = pageRoutes
                                                    .pages.keys
                                                    .contains(
                                                        pageInfo.actionTarget);
                                                if (canPush) {
                                                  if (pageInfo.operation ==
                                                      'OPEN') {
                                                    Navigator.of(
                                                            viewService.context)
                                                        .pushNamed(pageInfo
                                                                .actionTarget ??
                                                            '');
                                                  } else {
                                                    Navigator.of(
                                                            viewService.context)
                                                        .pushReplacementNamed(
                                                            pageInfo.actionTarget ??
                                                                '');
                                                  }
                                                } else {
                                                  showToast(state
                                                      .languageResource!
                                                      .getUnsupportActivity(
                                                          pageInfo.actionTarget ??
                                                              ''));
                                                }
                                              } else {
                                                String pageUrl =
                                                    pageInfo.actionTarget ?? "";
                                                if (pageInfo.token ?? false) {
                                                  var userInfo = LocalStorage
                                                      .getCacheUserInfo();
                                                  if (pageInfo.actionTarget!
                                                      .contains("?")) {
                                                    pageUrl =
                                                        '$pageUrl&token=${userInfo?.accessToken ?? ''}';
                                                  } else {
                                                    pageUrl =
                                                        '$pageUrl?token=${userInfo?.accessToken ?? ''}';
                                                  }
                                                }
                                                var arguments = {
                                                  'pageUrl': pageUrl,
                                                  'title': pageInfo.name,
                                                  'callback': pageInfo.callback
                                                };

                                                if (pageInfo.operation ==
                                                    'OPEN') {
                                                  Navigator.of(
                                                          viewService.context)
                                                      .pushNamed('webviewPage',
                                                          arguments: arguments);
                                                } else {
                                                  Navigator.of(
                                                          viewService.context)
                                                      .pushReplacementNamed(
                                                          'webviewPage',
                                                          arguments: arguments);
                                                }
                                              }
                                            }),
                                      },
                                    ),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: DeepLinkHandler.waiting,
                          builder: (context, value, _) {
                            return Visibility(
                              visible: value,
                              child: Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        },
      ));
}
