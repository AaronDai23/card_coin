import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentHandleAction {
  action,
  add,
  edit,
  detail,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  parameter,
  smartCardCrypto,
  preloadData,
  ploadSuccess,
  selectCoin,
  textValue,
  update,
  oprate,
  history,
  forecast,
  preConfig,
  flowHistory,
}

enum InvestmentActionType { add, edit, detail, puase, stop, resume }

class InvestmentHandleActionCreator {
  static Action onAction() {
    return const Action(InvestmentHandleAction.action);
  }

  static Action onHistoryAction() {
    return const Action(InvestmentHandleAction.history);
  }

  static Action onPreAction() {
    return const Action(InvestmentHandleAction.preloadData);
  }

  static Action onPreConfigAction() {
    return const Action(InvestmentHandleAction.preConfig);
  }

  static Action onAddAction() {
    return const Action(InvestmentHandleAction.add);
  }

  static Action onEditAction() {
    return const Action(InvestmentHandleAction.edit);
  }

  static Action onForecastAction() {
    return const Action(InvestmentHandleAction.forecast);
  }

  static Action onOprateAction(InvestmentActionType type) {
    return Action(InvestmentHandleAction.oprate, payload: type);
  }

  static Action onUpdate() {
    return const Action(InvestmentHandleAction.update);
  }

  static Action parameterAction() {
    return const Action(InvestmentHandleAction.parameter);
  }

  static Action smartCardCryptoAction() {
    return const Action(InvestmentHandleAction.smartCardCrypto);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(InvestmentHandleAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(InvestmentInfo inviteListInfo) {
    return Action(InvestmentHandleAction.loadSuccess, payload: inviteListInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InvestmentHandleAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InvestmentHandleAction.showLoading);
  }

  static Action onProSuc() {
    return const Action(InvestmentHandleAction.ploadSuccess);
  }

  static Action onSelectCoin() {
    return const Action(InvestmentHandleAction.selectCoin);
  }

  static Action onTextChang(String value) {
    return Action(InvestmentHandleAction.textValue, payload: value);
  }

  static Action onFlowHistory() {
    return const Action(InvestmentHandleAction.flowHistory);
  }
}
