import 'package:card_coin/card_base/bean/task_detail_info.dart';
import 'package:card_coin/card_base/bean/task_summary_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum TaskRewardsAction {
  action,
  summaryInfo,
  taskList,
  upDataView,
  getSummaryInfo,
  getTaskList,
  loadSuccess,
  loadFailure,
  showLoading,
  receive
}

class TaskRewardsActionCreator {
  static Action onAction() {
    return const Action(TaskRewardsAction.action);
  }

  static Action onUpDataView() {
    return const Action(TaskRewardsAction.upDataView);
  }

  static Action onGetSummaryInfo() {
    return const Action(TaskRewardsAction.getSummaryInfo);
  }

  static Action onReceiveAction(String taskId) {
    return Action(TaskRewardsAction.receive, payload: taskId);
  }

  static Action onGetTaskList() {
    return const Action(TaskRewardsAction.getTaskList);
  }

  static Action onupdateSummaryInfo(TaskSummaryInfo summaryInfo) {
    return Action(TaskRewardsAction.summaryInfo, payload: summaryInfo);
  }

  static Action onupdateTaskList(List<TaskDetailInfo> taskList) {
    return Action(TaskRewardsAction.taskList, payload: taskList);
  }

  static Action onLoadSuccess(List<TaskDetailInfo> list) {
    return Action(TaskRewardsAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(TaskRewardsAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(TaskRewardsAction.showLoading);
  }
}
