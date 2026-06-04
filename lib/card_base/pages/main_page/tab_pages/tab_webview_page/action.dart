import 'package:fish_redux/fish_redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

//TODO replace with your own action
enum TabWebviewAction {
  loadDomain,
  showProgressIndicator,
  loadSuccess,
  loadFailure,
  showLoading,
  updateProgress,
  updateGoBack,
  updateGoForward,
  updateController,
  uploadRequestUrl,
  injectedObject,
  updateUnReadCount,
  parsedWalletUrl,
  goMainPage
}

class TabWebviewActionCreator {
  static Action onUpdateUnReadCount(int count) {
    return Action(TabWebviewAction.updateUnReadCount, payload: count);
  }

  static Action onParsedWalletUrl(Uri uri) {
    return Action(TabWebviewAction.parsedWalletUrl, payload: uri);
  }

  static Action onLoadSuccess(List<String> blackList) {
    return Action(TabWebviewAction.loadSuccess, payload: blackList);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(TabWebviewAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(TabWebviewAction.showLoading);
  }

  static Action onLoadDomain() {
    return const Action(TabWebviewAction.loadDomain);
  }

  static Action onShowProgressIndicator(bool isShow) {
    return Action(TabWebviewAction.showProgressIndicator, payload: isShow);
  }

  static Action onUpdateProgress(double progress) {
    return Action(TabWebviewAction.updateProgress, payload: progress);
  }

  static Action onUpdateGoBack(bool canGoBack) {
    return Action(TabWebviewAction.updateGoBack, payload: canGoBack);
  }

  static Action onUpdateGoForward(bool canGoForward) {
    return Action(TabWebviewAction.updateGoForward, payload: canGoForward);
  }

  static Action onUpdateController(WebViewController controller) {
    return Action(TabWebviewAction.updateController, payload: controller);
  }

  static Action onUploadRequestUrl(String url) {
    return Action(TabWebviewAction.uploadRequestUrl, payload: url);
  }

  static Action onInjectedObject(JavascriptMessage message) {
    return Action(TabWebviewAction.injectedObject, payload: message);
  }

  static Action onGoMainPage(int index) {
    return Action(TabWebviewAction.goMainPage, payload: index);
  }
}
