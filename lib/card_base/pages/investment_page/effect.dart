import 'dart:convert';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_handle_page/action.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:flutter/material.dart' hide Action;

import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentState>>{
    Lifecycle.initState: _onInit,
    InvestmentAction.loadData: _onLoadData,
    InvestmentAction.add: _onAddData,
    InvestmentAction.detail: _onDetailData,
    InvestmentAction.pushWalletPage: _onPushWalletClick,
    InvestmentAction.pushBalancePage: _onPushBalanceClick,
    InvestmentAction.activitedSucNofi: _onActivtedNoti,
  });
}

Future<void> _onInit(Action action, Context<InvestmentState> ctx) async {
  ctx.dispatch(InvestmentActionCreator.onLoadData());
}

Future<void> _onLoadData(Action action, Context<InvestmentState> ctx) async {
  Map<String, dynamic> params = {'uid': ctx.state.uid};
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.investmentPage, queryParameters: params);
  if (result.isSuccess) {
    if (result.data is String) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => ctx.state.refreshController.refreshCompleted());
      ctx.dispatch(InvestmentActionCreator.onLoadFailure("net data wrong"));
    }

    List<dynamic> list = result.data['rows'];
    List<InvestmentInfo> InvestmentList =
        list.map((e) => InvestmentInfo.fromJson(e)).toList();
    ctx.state.refreshController.loadComplete();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentActionCreator.onLoadSuccess(InvestmentList));
  } else {
    ctx.state.refreshController.refreshFailed();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onAddData(Action action, Context<InvestmentState> ctx) async {
  var result = await Navigator.of(ctx.context)
      .pushNamed('investmentHandlePage', arguments: {
    'actionType': InvestmentActionType.add,
    'uid': ctx.state.uid,
    'investmentConfig': ctx.state.investmentConfig
  });
  if (result != null) {
    ctx.dispatch(InvestmentActionCreator.onLoadData());
  }
}

Future<void> _onDetailData(Action action, Context<InvestmentState> ctx) async {
  InvestmentInfo inviteListInfo = action.payload;
  var result = await Navigator.of(ctx.context)
      .pushNamed('investmentHandlePage', arguments: {
    'actionType': InvestmentActionType.detail,
    'uid': ctx.state.uid,
    'id': inviteListInfo.id,
    'investmentConfig': ctx.state.investmentConfig
  });
  if (result != null) {
    ctx.dispatch(InvestmentActionCreator.onLoadData());
  }
}

Future<void> _onPushWalletClick(
    Action action, Context<InvestmentState> ctx) async {
  String cardId = action.payload;

  ///获取卡片信息缓存
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardId);
  print("_onPushWalletClick:$cardInfoJson");
  if (cardInfoJson?.isNotEmpty ?? false) {
    ///根据设备uuid初始化scanResponse,如果失败代表没有本地没有扫卡缓存数据，需要重新扫卡
    var success = await BlockchainPlatform.instance.initScanResponse(cardId);
    print("_onPushWalletClick_success;$success");
    if (success) {
      var cardInfo = CardInfo.fromJson(json.decode(cardInfoJson!));
      Navigator.of(ctx.context)
          .pushNamed('cardWalletListPage', arguments: {'cardInfo': cardInfo});
      return;
    }
  }
  print("_onPushWalletClick1");
  Navigator.of(ctx.context)
      .pushNamed('scanWalletPage', arguments: {'cardId': cardId});
}

Future<void> _onPushBalanceClick(
    Action action, Context<InvestmentState> ctx) async {
  String cardId = action.payload;

  Navigator.of(ctx.context)
      .pushNamed('investmentBalancePage', arguments: {'uid': cardId});
}

Future<void> _onActivtedNoti(
    Action action, Context<InvestmentState> ctx) async {
  if (ctx.state.investmentConfig != null) {
    ctx.broadcast(InvestmentActionCreator.onActivitedSucCard());
    // Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(ctx.context).pop();
    // });
  } else {
    Navigator.of(ctx.context).pop();
  }
}
