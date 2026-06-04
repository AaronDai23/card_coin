import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  add,
  detail,
  pushWalletPage,
  pushBalancePage,
  activitedSucCard,
  activitedSucNofi,
}

class InvestmentActionCreator {
  static Action onAction() {
    return const Action(InvestmentAction.action);
  }

  static Action addAction() {
    return const Action(InvestmentAction.add);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(InvestmentAction.loadData, payload: isLoadMore);
  }

  static Action onDetailData(InvestmentInfo inviteListInfo) {
    return Action(InvestmentAction.detail, payload: inviteListInfo);
  }

  static Action onLoadSuccess(List<InvestmentInfo> inviteListInfos) {
    return Action(InvestmentAction.loadSuccess, payload: inviteListInfos);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentAction.showLoading);
  }

  static Action onPushWalletPage(String cardId) {
    return Action(InvestmentAction.pushWalletPage, payload: cardId);
  }

  static Action onPusBalancePage(String cardId) {
    return Action(InvestmentAction.pushBalancePage, payload: cardId);
  }

  static Action onActivitedSucCard() {
    return const Action(InvestmentAction.activitedSucCard);
  }

  static Action onActivitedNofi() {
    return const Action(InvestmentAction.activitedSucNofi);
  }
}
