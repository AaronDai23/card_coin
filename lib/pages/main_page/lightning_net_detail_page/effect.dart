import 'dart:async';

import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/light_spark_transactions.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';
Effect<LightningNetDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<LightningNetDetailState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    // LightningNetDetailAction.action: _onAction,
    LightningNetDetailAction.loadData: _onLoadData,
    LightningNetDetailAction.lightningNet: _onLightningNet,
    LightningNetDetailAction.lightningNetSend: _onSendLightningNet,
    LightningNetDetailAction.lightningNetSendAlert: _onSendLightningNetAlert,
    LightningNetDetailAction.startTime: _onStartTime,
    LightningNetDetailAction.receive: _onReceive,
    LightningNetDetailAction.sendInvoice: _onSendInvoice,
    LightningNetDetailAction.withdrawLightning: _onWithdrawLightning,
  });
}

void _onInit(Action action, Context<LightningNetDetailState> ctx) {
  // CurrencyInfo info = ctx.state.bigCurrency;
  // if (info.address != null) {
  ctx.dispatch(LightningNetDetailActionCreator.onGetLightningNetDetail());

  ctx.dispatch(LightningNetDetailActionCreator.onLoadData());
  ctx.dispatch(LightningNetDetailActionCreator.onStartTime());
  // }
}

void _onDispose(Action action, Context<LightningNetDetailState> ctx) {
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }
}

void _onWithdrawLightning(Action action, Context<LightningNetDetailState> ctx) {
  if (num.parse(ctx.state.flashBalanceDetail!.amountValue) == 0) {
    showToast("Lightning amountValue is zero, can't withdrawal");
    return;
  }

  Navigator.of(ctx.context).pushNamed('withdrawLightningPage', arguments: {
    'uid': ctx.state.uid,
    'flashBalanceDetail': ctx.state.flashBalanceDetail
  });
}

Future<void> _onLoadData(
    Action action, Context<LightningNetDetailState> ctx) async {
  bool isLoadMore = action.payload;
  int currentPage = ctx.state.currentPage;

  Map<String, dynamic> params = {
    'page': isLoadMore ? currentPage + 1 : currentPage,
    'uid': ctx.state.uid,
    'rows': pageSize
  };
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.lightSparkTransactions, queryParameters: params);
  if (result.isSuccess) {
    if (isLoadMore) {
      ctx.state.currentPage++;
    }

    print("lightSparkTransactions:${result.data}");
    int total = result.data['total'];
    List<LightSparkTransactions> lights = (result.data['rows'] as List)
        .map((e) => LightSparkTransactions.fromJson(e))
        .toList()
        .cast<LightSparkTransactions>();

    if (ctx.state.currentPage * int.parse(pageSize) >= total) {
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
    ctx.dispatch(LightningNetDetailActionCreator.onLoadSuccess(lights));
  } else {
    if (isLoadMore) {
      ctx.state.refreshController.loadFailed();
    } else {
      ctx.state.refreshController.refreshFailed();
    }
    ctx.dispatch(LightningNetDetailActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onLightningNet(
    Action action, Context<LightningNetDetailState> ctx) async {
  var params = {
    'uid': ctx.state.uid,
  };
  final result = await HttpManager.getInstance()
      .get(NetworkAddress.lightSparkBalance, queryParameters: params);

  if (result.isSuccess) {
    LogUtil.d('result_onLightningNet.data2222:${result.data}');
    FlashBalance flashBalance = FlashBalance.fromJson(result.data);
    ctx.dispatch(
        LightningNetDetailActionCreator.onUpdatelightningNetValueAction(
            flashBalance));
  } else {}
}

Future<void> _onSendLightningNet(
    Action action, Context<LightningNetDetailState> ctx) async {
  var params = {
    'uid': ctx.state.uid,
  };
  final result = await HttpManager.getInstance()
      .post(NetworkAddress.lightSparkWithdrawal, null, data: params);

  if (result.isSuccess) {
    LogUtil.d('result_onLightningNet.data2222:${result.data}');
    showToast("Lightning Withdrawal Success");
    Navigator.of(ctx.context).pop();
    ctx.dispatch(LightningNetDetailActionCreator.onGetLightningNetDetail());
    ctx.dispatch(LightningNetDetailActionCreator.onLoadData());
  } else {}
}

Future<void> _onSendLightningNetAlert(
    Action action, Context<LightningNetDetailState> ctx) async {
  if (num.tryParse(ctx.state.flashBalanceDetail!.amountValue) == 0) {
    showToast("Lightning amountValue is zero, can't withdrawal");
    return;
  }
  var reslut = await showDialog(
      context: ctx.context,
      builder: (BuildContext context) {
        return const ZenggeTextAlertDialog(
          'Withdrawal all Lightning Balance to your BTC ?',
          enableCancel: true,
        );
      });
  if (reslut == true) {
    ctx.dispatch(LightningNetDetailActionCreator.onSendLightningNet());
  }
}

Future<void> _onStartTime(
    Action action, Context<LightningNetDetailState> ctx) async {
  const oneSec = Duration(seconds: 1);
  if (ctx.state.homeTimer != null) {
    ctx.state.homeTimer!.cancel();
  }

  ctx.state.homeTimer = Timer.periodic(oneSec, (Timer timer) {
    ctx.state.homeSeconds--;

    if (ctx.state.homeSeconds == 0) {
      ctx.state.homeSeconds = 60;
      ctx.dispatch(LightningNetDetailActionCreator.onGetLightningNetDetail());
    } else {
      ctx.dispatch(
          LightningNetDetailActionCreator.onUpdateTime(ctx.state.homeSeconds));
    }
  });
}

Future<void> _onReceive(
    Action action, Context<LightningNetDetailState> ctx) async {
  var result = await Navigator.of(ctx.context)
      .pushNamed('lightNetInvoicePage', arguments: {'uid': ctx.state.uid});
  if (result == true) {
    print("_editActionw.loca1");
  } else {
    print("_editActionloca0");
  }
}

Future<void> _onSendInvoice(
    Action action, Context<LightningNetDetailState> ctx) async {
  if (num.parse(ctx.state.flashBalanceDetail!.amountValue) == 0) {
    showToast("Lightning amountValue is zero, can't send invoice");
    return;
  }
  await Navigator.of(ctx.context)
      .pushNamed('sendLightningInvoicePage', arguments: {
    'uid': ctx.state.uid,
    'flashBalanceDetail': ctx.state.flashBalanceDetail
  });
}
