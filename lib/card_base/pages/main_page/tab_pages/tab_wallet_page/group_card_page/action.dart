import 'package:card_coin/card_base/bean/card_group_bean.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum GroupCardAction {
  loadData,
  loadSuccess,
  loadFailure,
  showLoading,
  scanCard,
  updateRemark,
  updateUnReadCount
}

class GroupCardActionCreator {
  static Action onLoadData({bool isLoadMore = false}) {
    return Action(GroupCardAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(CardGroupListInfo groupListInfo) {
    return Action(GroupCardAction.loadSuccess, payload: groupListInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(GroupCardAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(GroupCardAction.showLoading);
  }

  static Action onScanCard() {
    return const Action(GroupCardAction.scanCard);
  }

  static Action onUpdateRemark(String id, String remark) {
    return Action(GroupCardAction.updateRemark,
        payload: {'id': id, 'remark': remark});
  }

  static Action onUpdateUnReadCount(int readCount) {
    return Action(GroupCardAction.updateUnReadCount, payload: readCount);
  }
}
