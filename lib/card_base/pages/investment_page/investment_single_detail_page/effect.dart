import 'dart:convert';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/investment_single_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentSingleDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentSingleDetailState>>{
    Lifecycle.initState: _onInit,
    InvestmentSingleDetailAction.action: _onAction,
    InvestmentSingleDetailAction.loadData: _onLoadData,
    InvestmentSingleDetailAction.stop: _onStop,
    InvestmentSingleDetailAction.pushWallet: _onPushWalletClick,
    InvestmentSingleDetailAction.flowHistory: _onFlowHistory,
  });
}

void _onAction(Action action, Context<InvestmentSingleDetailState> ctx) {}

Future<void> _onInit(
    Action action, Context<InvestmentSingleDetailState> ctx) async {
  ctx.dispatch(InvestmentSingleDetailActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<InvestmentSingleDetailState> ctx) async {
  Map<String, dynamic> params = {'uid': ctx.state.uid, 'id': ctx.state.id};
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.cardDetailSingleUrl, null, data: params);
  if (result.isSuccess) {
    if (result.data is String) {
      showToast("net data wrong");
      return;
    }

    var data = result.data;
    InvestmentSingleInfo investment = InvestmentSingleInfo.fromJson(data);
    print('_onLoadData-investment:${investment.toJson()}');

    ctx.dispatch(InvestmentSingleDetailActionCreator.onLoadSuccess(investment));
  } else {
    String errorMsg = result.message;
    showToast(errorMsg);
    ctx.dispatch(InvestmentSingleDetailActionCreator.onLoadFailure(errorMsg));
  }
}

Future<void> _onStop(
    Action action, Context<InvestmentSingleDetailState> ctx) async {
  Map<String, dynamic> params = {'uid': ctx.state.uid, 'id': ctx.state.id};
  String? url = NetworkAddress.pauseInvestment;
  if (ctx.state.investmentSingleInfo != null &&
      ctx.state.investmentSingleInfo!.status == 'TERMINATED') {
    url = NetworkAddress.resumeInvestment;
  }
  var result = await HttpManager.getInstance().post(url, null, data: params);
  if (result.isSuccess) {
    if (ctx.state.investmentSingleInfo != null &&
        ctx.state.investmentSingleInfo!.status == 'TERMINATED') {
      showToast("Resume Investment Success",
          duration: const Duration(milliseconds: 2000));
    } else {
      showToast("Stop Investment Success",
          duration: const Duration(milliseconds: 2000));
    }

    Navigator.of(ctx.context).pop(true);
  } else {
    showToast(result.message, duration: const Duration(milliseconds: 2000));
  }
}

Future<void> _onPushWalletClick(
    Action action, Context<InvestmentSingleDetailState> ctx) async {
  String cardId = ctx.state.uid;

  ///获取卡片信息缓存
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardId);
  if (cardInfoJson?.isNotEmpty ?? false) {
    ///根据设备uuid初始化scanResponse,如果失败代表没有本地没有扫卡缓存数据，需要重新扫卡
    var success = await BlockchainPlatform.instance.initScanResponse(cardId);
    if (success) {
      var cardInfo = CardInfo.fromJson(json.decode(cardInfoJson!));
      Navigator.of(ctx.context)
          .pushNamed('cardWalletListPage', arguments: {'cardInfo': cardInfo});
      return;
    }
  }
  Navigator.of(ctx.context).pushNamed('scanWalletPage', arguments: {
    'cardId': cardId,
  });
}

Future<void> _onFlowHistory(
    Action action, Context<InvestmentSingleDetailState> ctx) async {
  String cardId = ctx.state.uid;

  Navigator.of(ctx.context).pushNamed('flowHistoryPage', arguments: {
    'uid': cardId,
  });
}
