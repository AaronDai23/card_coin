import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum CoinMessageDetailAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData
}

class CoinMessageDetailActionCreator {
  static Action onAction() {
    return const Action(CoinMessageDetailAction.action);
  }

  static Action onLoadSuccess(CoinMessageDetail detail) {
    return Action(CoinMessageDetailAction.loadSuccess, payload: detail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(CoinMessageDetailAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(CoinMessageDetailAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(CoinMessageDetailAction.loadData);
  }
}
