import 'package:card_coin/card_base/bean/investment_history_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentHistoryAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData
}

class InvestmentHistoryActionCreator {
  static Action onAction() {
    return const Action(InvestmentHistoryAction.action);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(InvestmentHistoryAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(List<InvestmentHistoryInfo> inviteListInfos) {
    return Action(InvestmentHistoryAction.loadSuccess,
        payload: inviteListInfos);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentHistoryAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentHistoryAction.showLoading);
  }
}
