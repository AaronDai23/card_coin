
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum WebviewAction {
  action,
  updateProgress,
  parsedWalletUrl,
  showProgressIndicator,
  loadDomain,
  showLoading,
  loadSuccess,
  loadFailure,
  uploadRequestUrl
}

class WebviewActionCreator {
  static Action onShowLoading() {
    return const Action(WebviewAction.showLoading);
  }

  static Action onUpdateProgress(double progress) {
    return Action(WebviewAction.updateProgress, payload: progress);
  }

  static Action onParsedWalletUrl(Uri uri) {
    return Action(WebviewAction.parsedWalletUrl, payload: uri);
  }

  static Action onShowProgressIndicator(bool isShow) {
    return Action(WebviewAction.showProgressIndicator, payload: isShow);
  }

  static Action onLoadSuccess(List<String> blackList) {
    return Action(WebviewAction.loadSuccess, payload: blackList);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(WebviewAction.loadFailure, payload: errorMsg);
  }

  static Action onLoadDomain() {
    return const Action(WebviewAction.loadDomain);
  }

  static Action onUploadRequestUrl(String url) {
    return Action(WebviewAction.uploadRequestUrl,payload: url);
  }
}
