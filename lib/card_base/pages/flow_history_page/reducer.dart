import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FlowHistoryState>? buildReducer() {
  return asReducer(
    <Object, Reducer<FlowHistoryState>>{
      FlowHistoryAction.action: _onAction,
      FlowHistoryAction.loadSuccess: _onLoadSuccess,
      FlowHistoryAction.loadFailure: _onLoadFailure,
      FlowHistoryAction.showLoading: _onShowLoading,
    },
  );
}

FlowHistoryState _onAction(FlowHistoryState state, Action action) {
  final FlowHistoryState newState = state.clone();
  return newState;
}

FlowHistoryState _onLoadSuccess(FlowHistoryState state, Action action) {
  List<FlowProgressNewInfo> steps = action.payload;
  final FlowHistoryState newState = state.clone()
    ..steps = steps
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

FlowHistoryState _onLoadFailure(FlowHistoryState state, Action action) {
  final FlowHistoryState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

FlowHistoryState _onShowLoading(FlowHistoryState state, Action action) {
  final FlowHistoryState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
