import 'package:fish_redux/fish_redux.dart';

import '../../bean/invite_bean.dart';

//TODO replace with your own action
enum InviteListAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData
}

class InviteListActionCreator {
  static Action onLoadData(bool isLoadMore) {
    return Action(InviteListAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess(InviteListInfo inviteListInfo) {
    return Action(InviteListAction.loadSuccess, payload: inviteListInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(InviteListAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(InviteListAction.showLoading);
  }
}
