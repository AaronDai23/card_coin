import 'package:fish_redux/fish_redux.dart';

import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../bean/invite_bean.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';
Effect<InviteListState>? buildEffect() {
  return combineEffects(<Object, Effect<InviteListState>>{
    Lifecycle.initState: _onInit,
    InviteListAction.loadData: _onLoadData,
  });
}

Future<void> _onInit(Action action, Context<InviteListState> ctx) async {
  ctx.dispatch(InviteListActionCreator.onLoadData(false));
}

Future<void> _onLoadData(Action action, Context<InviteListState> ctx) async {
  bool isLoadMore = action.payload ? action.payload : false;
  int currentPage = ctx.state.currentPage;

  Map<String, dynamic> params = {
    'page': isLoadMore ? currentPage + 1 : currentPage,
    'rows': pageSize
  };
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.inviteListUrl, queryParameters: params);
  if (result.isSuccess) {
    if (isLoadMore) {
      ctx.state.currentPage++;
    }

    var inviteListInfo = InviteListInfo.fromJson(result.data);
    if (ctx.state.currentPage * int.parse(pageSize) >= inviteListInfo.total!) {
      if (!isLoadMore) {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
      ctx.state.refreshController.loadNoData();
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
    }
    ctx.dispatch(InviteListActionCreator.onLoadSuccess(inviteListInfo));
  } else {
    if (isLoadMore) {
      ctx.state.refreshController.loadFailed();
    } else {
      ctx.state.refreshController.refreshFailed();
    }
    ctx.dispatch(InviteListActionCreator.onLoadFailure(result.message));
  }
}
