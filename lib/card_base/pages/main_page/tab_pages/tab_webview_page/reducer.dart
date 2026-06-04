
import 'package:fish_redux/fish_redux.dart';

import '../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<TabWebviewState>? buildReducer() {
  return asReducer(
    <Object, Reducer<TabWebviewState>>{
      TabWebviewAction.updateProgress: _onUpdateProgress,
      TabWebviewAction.loadSuccess: _onLoadSuccess,
      TabWebviewAction.loadFailure: _onLoadFailure,
      TabWebviewAction.showLoading: _onShowLoading,
      TabWebviewAction.showProgressIndicator: _onShowProgressIndicator,
      TabWebviewAction.updateGoBack: _onUpdateGoBack,
      TabWebviewAction.updateGoForward: _onUpdateGoForward,
      TabWebviewAction.updateController: _onUpdateController,
      TabWebviewAction.updateUnReadCount: _onUpdateUnReadCount,
    },
  );
}

TabWebviewState _onUpdateUnReadCount(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()
    ..unReadCount = action.payload
  ;
  return newState;
}

TabWebviewState _onLoadSuccess(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..blackList = action.payload
  ;
  return newState;
}

TabWebviewState _onLoadFailure(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
TabWebviewState _onShowLoading(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

TabWebviewState _onShowProgressIndicator(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()..showProgress = action.payload;
  return newState;
}

TabWebviewState _onUpdateGoBack(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()..canGoback = action.payload;
  return newState;
}

TabWebviewState _onUpdateGoForward(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()..canGoforward = action.payload;
  return newState;
}

TabWebviewState _onUpdateProgress(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()..progress = action.payload;
  return newState;
}
TabWebviewState _onUpdateController(TabWebviewState state, Action action) {
  final TabWebviewState newState = state.clone()..controller = action.payload;
  return newState;
}
