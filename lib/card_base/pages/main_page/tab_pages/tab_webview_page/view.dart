import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/reown_wallet/bottom_sheet/bottom_sheet_listener.dart';
import 'package:card_coin/reown_wallet/deep_link_handler.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../widget/base_page_loading.dart';
import '../../../../../widget/custom_alert_dialog.dart';
import '../../../../widgets/message_bell_widget.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    TabWebviewState state, Dispatch dispatch, ViewService viewService) {
  var name = state.categoryItem.name ?? '';
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(
        name == 'Dapp' ? "" : name,
        style: const TextStyle(fontSize: 20.0),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              dispatch(TabWebviewActionCreator.onGoMainPage(0));
            },
            icon: const Icon(Icons.close)),
        IconButton(
            onPressed: () async {
              var canBack = (await state.controller?.canGoBack()) ?? false;
              if (canBack) {
                state.controller?.goBack();
              }
            },
            icon: const Icon(Icons.arrow_back)),
        IconButton(
            onPressed: () async {
              var canBack = (await state.controller?.canGoForward()) ?? false;
              if (canBack) {
                state.controller?.goForward();
              }
            },
            icon: const Icon(Icons.arrow_forward)),
        IconButton(
            onPressed: () => state.controller?.reload(),
            icon: const Icon(Icons.refresh)),
        IconButton(
            onPressed: () => Navigator.of(viewService.context)
                .pushNamed('cardBaseSettingsPage'),
            icon: const Icon(Icons.settings)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MessageBellWidget(
              unReadCount: state.unReadCount,
              onTap: () {
                Navigator.of(viewService.context)
                    .pushNamed('messageManagerPage');
              },
            ),
          ),
        ),
      ],
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(TabWebviewActionCreator.onShowLoading());
        dispatch(TabWebviewActionCreator.onLoadDomain());
      },
      buildBody: (isSuccess) {
        if (isSuccess) {
          var locale = state.languageLocale!;

          String pageUrl = state.categoryItem.target!;
          if (pageUrl.contains("?")) {
            pageUrl =
                '$pageUrl&language=${locale.languageCode}_${locale.countryCode}';
          } else {
            pageUrl =
                '$pageUrl?language=${locale.languageCode}_${locale.countryCode}';
          }

          if (state.categoryItem.token ?? false) {
            pageUrl = '$pageUrl&token=${state.userInfo.accessToken ?? ''}';
          }

          return BottomSheetListener(
            child: Stack(
              children: [
                Column(
                  children: [
                    Opacity(
                      opacity: state.showProgress ? 1 : 0,
                      child: LinearProgressIndicator(
                        value: state.progress,
                        backgroundColor: Colors.white,
                        minHeight: 2,
                      ),
                    ),
                    Expanded(
                      child: WebView(
                        onWebViewCreated: (WebViewController controller) {
                          dispatch(TabWebviewActionCreator.onUpdateController(
                              controller));
                        },
                        navigationDelegate: (NavigationRequest request) {
                          String url = request.url;
                          final uri = Uri.tryParse(request.url);
                          if (uri != null) {
                            if (uri.scheme == 'wc') {
                              dispatch(
                                  TabWebviewActionCreator.onParsedWalletUrl(
                                      uri));
                              return NavigationDecision.prevent;
                            }
                          }

                          var isPrevent = state.blackList
                              .any((element) => url.startsWith(element));
                          dispatch(
                              TabWebviewActionCreator.onUploadRequestUrl(url));
                          // if (!isPrevent) {
                          //   dispatch(TabWebviewActionCreator.onUploadRequestUrl(url));
                          // }
                          return isPrevent
                              ? NavigationDecision.prevent
                              : NavigationDecision.navigate;
                        },
                        onWebResourceError: (WebResourceError error) {
                          showDialog(
                              context: viewService.context,
                              builder: (context) {
                                return ZenggeTextAlertDialog(error.description);
                              });
                        },
                        onPageFinished: (url) {
                          dispatch(
                              TabWebviewActionCreator.onShowProgressIndicator(
                                  false));
                        },
                        onPageStarted: (url) async {
                          dispatch(
                              TabWebviewActionCreator.onShowProgressIndicator(
                                  true));
                        },
                        onProgress: (int progress) => dispatch(
                            TabWebviewActionCreator.onUpdateProgress(
                                progress / 100)),
                        initialUrl: pageUrl,
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: {
                          JavascriptChannel(
                              name: 'injectedObject',
                              onMessageReceived: (JavascriptMessage message) =>
                                  dispatch(
                                      TabWebviewActionCreator.onInjectedObject(
                                          message))),
                        },
                      ),
                    ),
                  ],
                ),
// <<<<<<< HEAD
//               ),
//               Expanded(
//                 child: WebView(
//                   onWebViewCreated: (WebViewController controller) {
//                     dispatch(
//                         TabWebviewActionCreator.onUpdateController(controller));
//                   },
//                   navigationDelegate: (NavigationRequest request) {
//                     String url = request.url;
//                     var isPrevent = state.blackList
//                         .any((element) => url.startsWith(element));
//                     dispatch(TabWebviewActionCreator.onUploadRequestUrl(url));
//                     // if (!isPrevent) {
//                     //   dispatch(TabWebviewActionCreator.onUploadRequestUrl(url));
//                     // }
//                     return isPrevent
//                         ? NavigationDecision.prevent
//                         : NavigationDecision.navigate;
//                   },
//                   onWebResourceError: (WebResourceError error) {
//                     dispatch(TabWebviewActionCreator.onLoadFailure(
//                         error.description));
//                     // showDialog(
//                     //     context: viewService.context,
//                     //     builder: (context) {
//                     //       return ZenggeTextAlertDialog(error.description);
//                     //     });
//                   },
//                   onPageFinished: (url) {
//                     dispatch(
//                         TabWebviewActionCreator.onShowProgressIndicator(false));
//                   },
//                   onPageStarted: (url) async {
//                     dispatch(
//                         TabWebviewActionCreator.onShowProgressIndicator(true));
//                   },
//                   onProgress: (int progress) => dispatch(
//                       TabWebviewActionCreator.onUpdateProgress(progress / 100)),
//                   initialUrl: pageUrl,
//                   javascriptMode: JavascriptMode.unrestricted,
//                   javascriptChannels: {
//                     JavascriptChannel(
//                         name: 'injectedObject',
//                         onMessageReceived: (JavascriptMessage message) =>
//                             dispatch(TabWebviewActionCreator.onInjectedObject(
//                                 message))),
// =======
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
          );
        } else {
          return const SizedBox();
        }
      },
    ),
  );
}
