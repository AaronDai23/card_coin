import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WebviewState>? buildReducer() {
  return asReducer(
    <Object, Reducer<WebviewState>>{
      WebviewAction.action: _onAction,
      WebviewAction.updateProgress: _onUpdateProgress,
      WebviewAction.showProgressIndicator: _onShowProgressIndicator,
    },
  );
}

WebviewState _onAction(WebviewState state, Action action) {
  final WebviewState newState = state.clone();
  return newState;
}

WebviewState _onUpdateProgress(WebviewState state, Action action) {
  final double progress = action.payload as double;
  final int currentPercent = (progress * 100).round();

  // 仅在每 5% 或到达 100% 时刷新进度，避免高频重建影响 WebView 流畅度。
  final bool shouldUpdate =
      currentPercent == 100 || currentPercent - state.lastProgressPercent >= 5;
  if (!shouldUpdate) return state;

  final WebviewState newState = state.clone()
    ..progress = progress
    ..lastProgressPercent = currentPercent;
  return newState;
}

WebviewState _onShowProgressIndicator(WebviewState state, Action action) {
  final bool isShow = action.payload as bool;
  final WebviewState newState = state.clone()
    ..showProgress = isShow
    ..lastProgressPercent = isShow ? 0 : state.lastProgressPercent;
  return newState;
}
