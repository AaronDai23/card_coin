import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentActiveAction {
  action,
  showLoading,
  loadSuccess,
  loadFailed,
  loadDefaultCurrency,
  scanCard,
  synsWalletInfo,
  activiteCard,
  preActiviteCard,
  approvalDCA,
  backClick,
  activitedSucCard,
  updateActivitedStatus,
  pushActivtedView,
  normalActiviteCard,
  normalSynsWalletInfo,
  normalPushActivtedView,
}

enum ActivitedStatus { PreActivite, scanActivite, finActivite }

class InvestmentActiveActionCreator {
  static Action onAction() {
    return const Action(InvestmentActiveAction.action);
  }

  static Action onShowLoading() {
    return const Action(InvestmentActiveAction.showLoading);
  }

  static Action onLoadSuccess(List<CurrencyInfo> currencyList) {
    return Action(InvestmentActiveAction.loadSuccess, payload: currencyList);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(InvestmentActiveAction.loadFailed, payload: errorMsg);
  }

  static Action onUpdateActivedStatus(ActivitedStatus status) {
    return Action(InvestmentActiveAction.updateActivitedStatus,
        payload: status);
  }

  static Action onPushActivtedView() {
    return const Action(
      InvestmentActiveAction.pushActivtedView,
    );
  }

  static Action onLoadDefaultCurrency() {
    return const Action(InvestmentActiveAction.loadDefaultCurrency);
  }

  static Action onScanCard() {
    return const Action(InvestmentActiveAction.scanCard);
  }

  static Action onActivitedSucCard() {
    return const Action(InvestmentActiveAction.activitedSucCard);
  }

  static Action onSynsWalletInfo(List<CurrencyInfo> list1) {
    return Action(InvestmentActiveAction.synsWalletInfo, payload: list1);
  }

  static Action onActiviteCard() {
    return const Action(InvestmentActiveAction.activiteCard);
  }

  static Action onPreActiviteCard() {
    return const Action(InvestmentActiveAction.preActiviteCard);
  }

  static Action onApprovalDCA() {
    return const Action(InvestmentActiveAction.approvalDCA);
  }

  static Action onBackClick() {
    return const Action(InvestmentActiveAction.backClick);
  }

  static Action onNormalSynsWalletInfo(List<CurrencyInfo> list1) {
    return Action(InvestmentActiveAction.normalSynsWalletInfo, payload: list1);
  }

  static Action onNormalPushActivtedView() {
    return const Action(
      InvestmentActiveAction.normalPushActivtedView,
    );
  }

  static Action onNormalActiviteCard() {
    return const Action(InvestmentActiveAction.normalActiviteCard);
  }
}
