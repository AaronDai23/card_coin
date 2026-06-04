import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SingleActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SingleActivateState>>{
      SingleActivateAction.action: _onAction,
      SingleActivateAction.loadSuccess: _onLoadSuccess,
      SingleActivateAction.loadFailure: _onLoadFailure,
      SingleActivateAction.showLoading: _onShowLoading,

    },
  );
}

SingleActivateState _onAction(SingleActivateState state, Action action) {
  final SingleActivateState newState = state.clone();
  return newState;
}

SingleActivateState _onLoadSuccess(SingleActivateState state, Action action) {
  final SingleActivateState newState = state.clone()
    ..activateSummary = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

SingleActivateState _onLoadFailure(SingleActivateState state, Action action) {
  final SingleActivateState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

SingleActivateState _onShowLoading(SingleActivateState state, Action action) {
  final SingleActivateState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
