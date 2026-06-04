import 'package:card_coin/card_base/bean/points_history_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum MemberPointsAction { action,loadData,loadSuccess,loadFailed,showLoading }

class MemberPointsActionCreator {
  static Action onAction() {
    return const Action(MemberPointsAction.action);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(MemberPointsAction.loadData,payload: isLoadMore);
  }


  static Action onLoadSuccess(PointsHistoryInfo listInfo,{bool isMore = false}) {
    return Action(MemberPointsAction.loadSuccess,payload: {'listInfo':listInfo,'isMore':isMore});
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(MemberPointsAction.loadFailed,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MemberPointsAction.showLoading);
  }

}
