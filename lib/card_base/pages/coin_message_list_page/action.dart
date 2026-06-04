import 'package:card_coin/card_base/bean/coin_message_summary.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum CoinMessageListAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
}

class CoinMessageListActionCreator {
  static Action onAction() {
    return const Action(CoinMessageListAction.action);
  }

  static Action onLoadSuccess(CoinMessageSummary summary,
      {bool isMore = false}) {
    return Action(CoinMessageListAction.loadSuccess,
        payload: {'summary': summary, 'isMore': isMore});
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(CoinMessageListAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(CoinMessageListAction.showLoading);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(CoinMessageListAction.loadData, payload: isLoadMore);
  }
}
