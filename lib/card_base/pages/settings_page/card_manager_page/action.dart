
import 'package:fish_redux/fish_redux.dart';

import '../../../bean/link_bean.dart';

//TODO replace with your own action
enum CardManagerAction {
  loadData,
  loadSuccess,
  loadFailure,
  showLoading,
  addCardClick,
  deleteItem
}

class CardManagerActionCreator {
  static Action onLoadData({bool isLoadMore = false}) {
    return Action(CardManagerAction.loadData,payload: isLoadMore);
  }

  static Action onLoadSuccess(CardListInfo cardListInfo) {
    return Action(CardManagerAction.loadSuccess,payload: cardListInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(CardManagerAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(CardManagerAction.showLoading);
  }

  static Action onAddCardClick() {
    return const Action(CardManagerAction.addCardClick);
  }

  static Action onDeleteItem(String id) {
    return Action(CardManagerAction.deleteItem,payload: id);
  }
}
