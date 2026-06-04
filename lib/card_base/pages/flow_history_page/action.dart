import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum FlowHistoryAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
}

class FlowHistoryActionCreator {
  static Action onAction() {
    return const Action(FlowHistoryAction.action);
  }

  static Action onLoadSuccess(List<FlowProgressNewInfo> steps) {
    return Action(FlowHistoryAction.loadSuccess, payload: steps);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(FlowHistoryAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(FlowHistoryAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(FlowHistoryAction.loadData);
  }
}
