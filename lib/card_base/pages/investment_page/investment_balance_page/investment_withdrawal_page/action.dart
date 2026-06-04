import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentWithdrawalAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  textValue,
  withdrawal,
  loadData,
  update,
  showNetworks,
  pushWalletPage,
}

class InvestmentWithdrawalActionCreator {
  static Action onAction() {
    return const Action(InvestmentWithdrawalAction.action);
  }

  static Action onShowNetworks() {
    return const Action(InvestmentWithdrawalAction.showNetworks);
  }

  static Action onLoadData() {
    return const Action(InvestmentWithdrawalAction.loadData);
  }

  static Action onLoadSuccess(InvestmentBalance detail) {
    return Action(InvestmentWithdrawalAction.loadSuccess, payload: detail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentWithdrawalAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentWithdrawalAction.showLoading);
  }

  static Action onTextChang(String value) {
    return Action(InvestmentWithdrawalAction.textValue, payload: value);
  }

  static Action onUpdate() {
    return const Action(InvestmentWithdrawalAction.update);
  }

  static Action onWithdrawal() {
    return const Action(InvestmentWithdrawalAction.withdrawal);
  }

  static Action onPushWalletPage() {
    return const Action(InvestmentWithdrawalAction.pushWalletPage);
  }
}
