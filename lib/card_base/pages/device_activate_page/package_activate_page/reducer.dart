import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PackageActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PackageActivateState>>{
      PackageActivateAction.action: _onAction,
      PackageActivateAction.loadSuccess: _onLoadSuccess,
      PackageActivateAction.loadFailure: _onLoadFailure,
      PackageActivateAction.showLoading: _onShowLoading,
      PackageActivateAction.updateSelectedList: _onUpdateSelectedList,
    },
  );
}

PackageActivateState _onAction(PackageActivateState state, Action action) {
  final PackageActivateState newState = state.clone();
  return newState;
}

PackageActivateState _onLoadSuccess(PackageActivateState state, Action action) {
  final PackageActivateState newState = state.clone()
    ..activateSummary = action.payload['summaryInfo']
    ..packageList = action.payload['packageList']
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

PackageActivateState _onLoadFailure(PackageActivateState state, Action action) {
  final PackageActivateState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

PackageActivateState _onShowLoading(PackageActivateState state, Action action) {
  final PackageActivateState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

PackageActivateState _onUpdateSelectedList(PackageActivateState state, Action action) {
  final PackageActivateState newState = state.clone()..selectedList = action.payload;
  return newState;
}

