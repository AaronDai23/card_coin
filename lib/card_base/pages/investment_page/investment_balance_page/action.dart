import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentBalanceAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  pushDetail
}

class InvestmentBalanceActionCreator {
  static Action onAction() {
    return const Action(InvestmentBalanceAction.action);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(InvestmentBalanceAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(List<InvestmentBalance> inviteListInfos) {
    return Action(InvestmentBalanceAction.loadSuccess,
        payload: inviteListInfos);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentBalanceAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentBalanceAction.showLoading);
  }

  static Action onSelectedAction(int index) {
    return Action(InvestmentBalanceAction.pushDetail, payload: index);
  }
}
