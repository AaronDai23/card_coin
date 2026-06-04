import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/coin_message_summary.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';
Effect<CoinMessageListState>? buildEffect() {
  return combineEffects(<Object, Effect<CoinMessageListState>>{
    Lifecycle.initState: _onInit,
    CoinMessageListAction.loadData: _onLoadData,
  });
}

Future<void> _onInit(Action action, Context<CoinMessageListState> ctx) async {
  ctx.dispatch(CoinMessageListActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<CoinMessageListState> ctx) async {
  try {
    bool isLoadMore = action.payload;

    String? uid = await LocalStorage.getCardUuid() ?? "";

    print("CoinMessageListState4:uid:$uid,isLoadMore:$isLoadMore");
    Map<String, dynamic> params = {
      'page': isLoadMore ? ctx.state.currentPage + 1 : 1,
      'rows': pageSize,
      'uid': uid
    };
    var result = await HttpManager.getInstance()
        .get(NetworkAddress.chainStampPage, queryParameters: params);
    if (result.isSuccess) {
      if (isLoadMore) {
        ctx.state.currentPage++;
      } else {
        ctx.state.currentPage = 1;
      }

      var listInfo = CoinMessageSummary.fromJson(result.data);
      if (ctx.state.currentPage * int.parse(pageSize) >= listInfo.total) {
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
      ctx.dispatch(CoinMessageListActionCreator.onLoadSuccess(listInfo,
          isMore: isLoadMore));
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadFailed();
      } else {
        ctx.state.refreshController.refreshFailed();
      }
      ctx.dispatch(CoinMessageListActionCreator.onLoadFailure(result.message));
    }
  } catch (error) {
    showToast("CoinMessageListState5:z${error.toString()}");
  }
}
