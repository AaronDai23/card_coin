import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AllActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AllActivateState>>{
      AllActivateAction.action: _onAction,
      AllActivateAction.loadSuccess: _onLoadSuccess,
      AllActivateAction.loadFailure: _onLoadFailure,
      AllActivateAction.showLoading: _onShowLoading,
    },
  );
}

AllActivateState _onAction(AllActivateState state, Action action) {
  final AllActivateState newState = state.clone();
  return newState;
}

AllActivateState _onLoadSuccess(AllActivateState state, Action action) {
  final AllActivateState newState = state.clone()
    ..activateSummary = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

AllActivateState _onLoadFailure(AllActivateState state, Action action) {
  final AllActivateState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

AllActivateState _onShowLoading(AllActivateState state, Action action) {
  final AllActivateState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
