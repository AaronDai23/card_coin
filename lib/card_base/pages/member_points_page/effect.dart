import 'package:card_coin/card_base/bean/points_history_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../bean/member_points_info.dart';
import 'action.dart';
import 'state.dart';
const String pageSize = '20';
Effect<MemberPointsState>? buildEffect() {
  return combineEffects(<Object, Effect<MemberPointsState>>{
    Lifecycle.initState: _onInit,
    MemberPointsAction.loadData: _onLoadData,
    MemberPointsAction.action: _onAction,
  });
}

Future<void> _onInit(Action action, Context<MemberPointsState> ctx) async {
  ctx.dispatch(MemberPointsActionCreator.onLoadData());
}

Future<void> _onLoadData(Action action, Context<MemberPointsState> ctx) async {

  if(ctx.state.memberPointsInfo == null){
    var result = await HttpManager.getInstance().get(NetworkAddress.memberPointsBalanceUrl);
    if(result.isSuccess){
      ctx.state.memberPointsInfo = MemberPointsInfo.fromJson(result.data);
    }else{
      ctx.dispatch(MemberPointsActionCreator.onLoadFailed(result.message));
      return;
    }
  }


  bool isLoadMore = action.payload;

  Map<String, dynamic> params = {
    'page': isLoadMore ? ctx.state.currentPage + 1 : 1,
    'rows': pageSize
  };
  var result =
      await HttpManager.getInstance().get(NetworkAddress.memberPointsRecordsUrl, queryParameters: params);
  if (result.isSuccess) {

    if (isLoadMore) {
      ctx.state.currentPage++;
    }else{
      ctx.state.currentPage = 1;
    }

    var listInfo = PointsHistoryInfo.fromJson(result.data);
    if (ctx.state.currentPage * int.parse(pageSize) >= listInfo.total!) {
      if (!isLoadMore) {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
      // if(int.parse(pageSize) >= listInfo.total!){
      //   ctx.state.refreshController.resetNoData();
      // }else{
        ctx.state.refreshController.loadNoData();
      // }

    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
    }
    ctx.dispatch(MemberPointsActionCreator.onLoadSuccess(listInfo,isMore: isLoadMore));
  } else {
    if (isLoadMore) {
      ctx.state.refreshController.loadFailed();
    } else {
      ctx.state.refreshController.refreshFailed();
    }
    ctx.dispatch(MemberPointsActionCreator.onLoadFailed(result.message));
  }
}

void _onAction(Action action, Context<MemberPointsState> ctx) {
}
