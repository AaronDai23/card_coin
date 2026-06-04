import 'package:card_coin/card_base/bean/task_detail_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TaskRewardsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<TaskRewardsState>>{
      TaskRewardsAction.action: _onAction,
      TaskRewardsAction.upDataView: _onUpDataView,
      TaskRewardsAction.summaryInfo: _onSummaryInfo,
      TaskRewardsAction.loadSuccess: _onLoadSuccess,
      TaskRewardsAction.loadFailure: _onLoadFailure,
      TaskRewardsAction.showLoading: _onShowLoading,
    },
  );
}

TaskRewardsState _onAction(TaskRewardsState state, Action action) {
  final TaskRewardsState newState = state.clone();
  return newState;
}

TaskRewardsState _onUpDataView(TaskRewardsState state, Action action) {
  final TaskRewardsState newState = state.clone();
  return newState;
}

TaskRewardsState _onSummaryInfo(TaskRewardsState state, Action action) {
  final TaskRewardsState newState = state.clone();
  newState.taskSummaryInfo = action.payload;
  return newState;
}

TaskRewardsState _onLoadSuccess(TaskRewardsState state, Action action) {
  List<TaskDetailInfo> list = action.payload;
  final TaskRewardsState newState = state.clone()
    ..tasks = list
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

TaskRewardsState _onLoadFailure(TaskRewardsState state, Action action) {
  final TaskRewardsState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

TaskRewardsState _onShowLoading(TaskRewardsState state, Action action) {
  final TaskRewardsState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
