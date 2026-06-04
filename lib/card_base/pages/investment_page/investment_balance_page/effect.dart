import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/http/address.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentBalanceState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentBalanceState>>{
    Lifecycle.initState: _onInit,
    InvestmentBalanceAction.loadData: _onLoadData,
    InvestmentBalanceAction.pushDetail: _onPushDetail,
  });
}

Future<void> _onInit(Action action, Context<InvestmentBalanceState> ctx) async {
  ctx.dispatch(InvestmentBalanceActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<InvestmentBalanceState> ctx) async {
  Map<String, dynamic> params = {
    'uid': ctx.state.uid,
  };
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.investmentBalance, queryParameters: params);
  if (result.isSuccess) {
    if (result.data is String) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => ctx.state.refreshController.refreshCompleted());
      ctx.dispatch(
          InvestmentBalanceActionCreator.onLoadFailure("net data wrong"));
    }

    List<dynamic> list = result.data;
    List<InvestmentBalance> investmentList =
        list.map((e) => InvestmentBalance.fromJson(e)).toList();
    ctx.state.refreshController.loadComplete();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentBalanceActionCreator.onLoadSuccess(investmentList));
  } else {
    ctx.state.refreshController.refreshFailed();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentBalanceActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onPushDetail(
    Action action, Context<InvestmentBalanceState> ctx) async {
  InvestmentBalance info = ctx.state.list[action.payload];

  await Navigator.of(ctx.context).pushNamed('investmentWithdrawalPage',
      arguments: {'detail': info, 'uid': ctx.state.uid});
}
