import 'package:card_coin/card_base/bean/investment_history_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentHistoryState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentHistoryState>>{
    Lifecycle.initState: _onInit,
    InvestmentHistoryAction.loadData: _onLoadData,
  });
}

Future<void> _onInit(Action action, Context<InvestmentHistoryState> ctx) async {
  ctx.dispatch(InvestmentHistoryActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<InvestmentHistoryState> ctx) async {
  Map<String, dynamic> params = {
    'uid': ctx.state.uid,
    'jobId': ctx.state.jobId
  };
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.investmentTransactions, queryParameters: params);
  if (result.isSuccess) {
    if (result.data is String) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => ctx.state.refreshController.refreshCompleted());
      ctx.dispatch(
          InvestmentHistoryActionCreator.onLoadFailure("net data wrong"));
    }

    List<dynamic> list = result.data['rows'];
    List<InvestmentHistoryInfo> investmentList =
        list.map((e) => InvestmentHistoryInfo.fromJson(e)).toList();
    ctx.state.refreshController.loadComplete();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentHistoryActionCreator.onLoadSuccess(investmentList));
  } else {
    ctx.state.refreshController.refreshFailed();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentHistoryActionCreator.onLoadFailure(""));
  }
}
