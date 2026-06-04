import 'package:card_coin/card_base/bean/investment_single_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentSingleDetailAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  stop,
  pushWallet,
  flowHistory,
}

class InvestmentSingleDetailActionCreator {
  static Action onAction() {
    return const Action(InvestmentSingleDetailAction.action);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(InvestmentSingleDetailAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(InvestmentSingleInfo investment) {
    return Action(InvestmentSingleDetailAction.loadSuccess,
        payload: investment);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentSingleDetailAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentSingleDetailAction.showLoading);
  }

  static Action onStop() {
    return const Action(InvestmentSingleDetailAction.stop);
  }

  static Action onPushWallet() {
    return const Action(InvestmentSingleDetailAction.pushWallet);
  }

  static Action onFlowHistory() {
    return const Action(InvestmentSingleDetailAction.flowHistory);
  }
}
