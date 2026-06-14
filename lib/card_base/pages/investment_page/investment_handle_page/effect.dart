import 'package:card_coin/bean/coin_info.dart';
import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:card_coin/card_base/bean/investment_forecast.dart';
import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/card_base/bean/investment_interval.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/managers/default_stablecoin_manager.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:collection/collection.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentHandleState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentHandleState>>{
    Lifecycle.initState: _onInit,
    InvestmentHandleAction.loadData: _onLoadData,
    InvestmentHandleAction.preloadData: _onLoadPreData,
    InvestmentHandleAction.selectCoin: _onSelectCoin,
    InvestmentHandleAction.add: _onAddAction,
    InvestmentHandleAction.edit: _onEditAction,
    InvestmentHandleAction.textValue: _onTextValue,
    InvestmentHandleAction.oprate: _onOperateAction,
    InvestmentHandleAction.history: _onPushHistoryAction,
    InvestmentHandleAction.forecast: _onForecastLoadData,
    InvestmentHandleAction.preConfig: _onPushHistoryAction,
    InvestmentHandleAction.flowHistory: _onFlowHistory,
  });
}

Future<void> _onInit(Action action, Context<InvestmentHandleState> ctx) async {
  ctx.dispatch(InvestmentHandleActionCreator.onPreAction());
}

Future<void> _onLoadPreData(
    Action action, Context<InvestmentHandleState> ctx) async {
  var result = await HttpManager.getInstance().get(
      NetworkAddress.investmentParameter,
      queryParameters: {"uid": ctx.state.uid});
  print("object-investmentParameter:${result.data}");
  if (result.isSuccess) {
    var data = result.data;

    InvestmentInterval investment = InvestmentInterval.fromJson(data);

    // var result2 = await HttpManager.getInstance().get(
    //     NetworkAddress.investmentBalance,
    //     queryParameters: {'uid': ctx.state.uid, 'unit': 'USDT'});
    // if (result2.isSuccess) {
    //   List<dynamic> list = result2.data;
    //   if (list.isEmpty) {
    //     var result = await showDialog(
    //         context: ctx.context,
    //         builder: (_) {
    //           return ZenggeTextAlertDialog(
    //             "Investment Balance is Empty, you can't create/edit investment plan",
    //             enableCancel: false,
    //             confirmText: "I know",
    //           );
    //         });
    //     if (result == true) {
    //       Navigator.pop(ctx.context);
    //     } else {}
    //     return;
    //   }
    //   String value = list[0]['balance'];
    //   ctx.state.totalCoin = double.tryParse(value)!;

    var result1 = await HttpManager.getInstance().get(
        NetworkAddress.investmentSmartCardCrypto,
        queryParameters: {'uid': ctx.state.uid});
    if (result1.isSuccess) {
      final stablecoin = await DefaultStablecoinManager.getCachedOrFallback();
      List<dynamic> list = result1.data;

      print('investmentSmartCardCrypto:${list.toString()}');
      List<CoinInfo> plist = list
          .map((e) {
            return CoinInfo.fromJson(e);
          })
          .where((element) => !DefaultStablecoinManager.equalsIgnoreCase(
              element.code, stablecoin))
          .toList();

      ctx.state.coinlist = plist;
      ctx.state.coinInfo = plist[ctx.state.selectedCoin];
      print(
          'investmentSmartCardCrypto-coinInfo:${ctx.state.coinInfo?.toJson()}');
      ctx.state.investment = investment;
      ctx.state.cycleInfo =
          ctx.state.investment.intervalUnit![ctx.state.selectedCycle];

      List<List<InvestmentSelectInfo>> columData =
          getColumData(ctx.state, ctx.context);
      if (columData.length == 3) {
        ctx.state.intervalExtend1 = 0;
        ctx.state.selectInfo1 = columData[0][0];
        ctx.state.intervalExtend2 = 0;
        ctx.state.selectInfo2 = columData[1][ctx.state.intervalExtend2];

        ctx.state.intervalExtend3 = 0;
        ctx.state.selectInfo3 = columData[2][ctx.state.intervalExtend3];
      } else if (columData.length == 2) {
        ctx.state.intervalExtend1 = 0;
        ctx.state.selectInfo1 = columData[0][ctx.state.intervalExtend1];

        ctx.state.intervalExtend2 = 0;
        ctx.state.selectInfo2 = columData[1][ctx.state.intervalExtend2];
      } else if (columData.length == 1) {
        ctx.state.intervalExtend1 = 0;
        ctx.state.selectInfo1 = columData[0][ctx.state.intervalExtend1];
      }
      print("_onInitsuccee");
      if (ctx.state.actionType == InvestmentActionType.detail) {
        ctx.dispatch(InvestmentHandleActionCreator.onLoadData());
      } else {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => ctx.state.refreshController.refreshCompleted());
        ctx.dispatch(InvestmentHandleActionCreator.onProSuc());
      }
    }
  } else {
    ctx.dispatch(InvestmentHandleActionCreator.onLoadFailure("net error"));
  }
}

Future<void> _onLoadData(
    Action action, Context<InvestmentHandleState> ctx) async {
  Map<String, dynamic> params = {'uid': ctx.state.uid, 'id': ctx.state.id};
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.investmentDetail, null, data: params);
  if (result.isSuccess) {
    if (result.data is String) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => ctx.state.refreshController.refreshCompleted());
      ctx.dispatch(
          InvestmentHandleActionCreator.onLoadFailure("net data wrong"));
    }

    var data = result.data;
    InvestmentInfo investment = InvestmentInfo.fromJson(data);
    print('_onLoadData-investment:${investment.toJson()}');
    CoinInfo? coinInfo;
    if (ctx.state.investmentConfig != null) {
      coinInfo = ctx.state.coinlist[0];
    } else {
      coinInfo = ctx.state.coinlist.firstWhereOrNull(
          (element) => element.address == investment.assetToAddress);
    }

    if (coinInfo == null) {
      var result = await showDialog(
          context: ctx.context,
          builder: (_) {
            return const ZenggeTextAlertDialog(
              "Investment can't find same  coin info",
              enableCancel: false,
              confirmText: "go back",
            );
          });
      if (result == true) {
        Navigator.of(ctx.context).pop();
      }
    }
    ctx.state.coinInfo = coinInfo;
    ctx.state.nameController.text = investment.name!;
    ctx.state.investmentName = investment.name!;
    if (ctx.state.investmentConfig != null) {
      ctx.state.amountController.text = investment.assetFromAmount!;
    } else {
      ctx.state.amountController.text = investment.assetFromAmount!;
    }

    ctx.state.mount = investment.assetFromAmount!;
    ctx.state.investDetail = investment;
    ctx.state.selectedCycle = ctx.state.investment.intervalUnit!
        .indexWhere((element) => element.value == investment.intervalType);
    ctx.state.cycleInfo =
        ctx.state.investment.intervalUnit![ctx.state.selectedCycle];

    List<List<InvestmentSelectInfo>> columData =
        getColumData(ctx.state, ctx.context);
    if (columData.length == 3) {
      if (investment.intervalExtend1 != null) {
        ctx.state.intervalExtend1 = columData[0].indexWhere(
            (element) => element.value == investment.intervalExtend1);
        ctx.state.selectInfo1 = columData[0][ctx.state.intervalExtend1];
      }
      if (investment.intervalExtend2 != null) {
        ctx.state.intervalExtend2 = columData[1].indexWhere(
            (element) => element.value == investment.intervalExtend2);
        ctx.state.selectInfo2 = columData[1][ctx.state.intervalExtend2];
      }
      if (investment.intervalExtend3 != null) {
        ctx.state.intervalExtend3 = columData[2].indexWhere(
            (element) => element.value == investment.intervalExtend3);
        ctx.state.selectInfo3 = columData[2][ctx.state.intervalExtend3];
      }
    } else if (columData.length == 2) {
      if (investment.intervalExtend1 != null) {
        ctx.state.intervalExtend1 = columData[0].indexWhere(
            (element) => element.value == investment.intervalExtend1);
        ctx.state.selectInfo1 = columData[0][ctx.state.intervalExtend1];
      }
      if (investment.intervalExtend2 != null) {
        ctx.state.intervalExtend2 = columData[1].indexWhere(
            (element) => element.value == investment.intervalExtend2);
        ctx.state.selectInfo2 = columData[1][ctx.state.intervalExtend2];
      }
    } else if (columData.length == 1) {
      if (investment.intervalExtend1 != null) {
        ctx.state.intervalExtend1 = columData[0].indexWhere(
            (element) => element.value == investment.intervalExtend1);
        ctx.state.selectInfo1 = columData[0][ctx.state.intervalExtend1];
      }
    }
    ctx.state.refreshController.loadComplete();

    ctx.dispatch(InvestmentHandleActionCreator.onLoadSuccess(investment));
  } else {
    ctx.state.refreshController.refreshFailed();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => ctx.state.refreshController.refreshCompleted());
    ctx.dispatch(InvestmentHandleActionCreator.onLoadFailure(""));
  }
}

Future<void> _onForecastLoadData(
    Action action, Context<InvestmentHandleState> ctx) async {
  if (!_checkMount(action, ctx)) {
    return;
  }
  final stablecoin = await DefaultStablecoinManager.getCachedOrFallback();
  ctx.state.isShowForecast = true;

  var smartCardCryptoId = ctx.state.coinInfo!.id;
  var intervalType =
      ctx.state.investment.intervalUnit![ctx.state.selectedCycle].value;
  var intervalExtend1 = "";
  var intervalExtend2 = "";
  var intervalExtend3 = "";
  if (ctx.state.selectInfo1 != null) {
    intervalExtend1 = ctx.state.selectInfo1!.value;
  }
  if (ctx.state.selectInfo2 != null) {
    intervalExtend2 = ctx.state.selectInfo2!.value;
  }
  if (ctx.state.selectInfo3 != null) {
    intervalExtend3 = ctx.state.selectInfo3!.value;
  }

  var parameters = {
    'assetFromAmount': ctx.state.mount,
    'uid': ctx.state.uid,
    'name': ctx.state.investmentName,
    "assetFromType": "CRYPTO",
    "assetFrom": (ctx.state.investDetail != null &&
            ctx.state.investDetail!.investmentConfig != null &&
            (ctx.state.investDetail!.investmentConfig!
                        .investmentAssetDestination ==
                    'WITHDRAW' ||
                ctx.state.investDetail!.investmentConfig!
                        .investmentAssetDestination ==
                    'CENTRALIZED'))
        ? stablecoin
        : ctx.state.investDetail!.assetFrom,
    "assetToType": "CRYPTO",
    "assetToAddress": ctx.state.coinInfo!.address!,
    'assetTo': (ctx.state.investDetail != null &&
            ctx.state.investDetail!.investmentConfig != null &&
            (ctx.state.investDetail!.investmentConfig!
                        .investmentAssetDestination ==
                    'WITHDRAW' ||
                ctx.state.investDetail!.investmentConfig!
                        .investmentAssetDestination ==
                    'CENTRALIZED'))
        ? ctx.state.coinInfo!.code!
        : (ctx.state.investDetail!.assetTo ?? ''),
    "smartCardCryptoId": smartCardCryptoId,
    "intervalType": intervalType,
    "intervalExtend1": intervalExtend1,
    "intervalExtend2": intervalExtend2,
    "intervalExtend3": intervalExtend3,
  };
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.investmentRorecast, null, data: parameters);
  if (result.isSuccess) {
    if (result.data is String) {
      showToast("data wrong");
    } else {
      var data = result.data;
      InvestmentForecast investment = InvestmentForecast.fromJson(data);
      ctx.state.investmentForecast = investment;
      ctx.dispatch(InvestmentHandleActionCreator.onProSuc());
    }
  }
}

List<List<InvestmentSelectInfo>> getColumData(
    InvestmentHandleState state, BuildContext ctx) {
  List<List<InvestmentSelectInfo>> pickerData = [];
  state.cycleInfo = state.investment.intervalUnit![state.selectedCycle];
  if (state.cycleInfo!.displayValue.contains("年") ||
      state.cycleInfo!.displayValue.contains("Year")) {
    pickerData = [
      state.investment.intervalMonth!,
      state.investment.intervalDay!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("月") ||
      state.cycleInfo!.displayValue.contains("Month")) {
    pickerData = [
      state.investment.intervalDay!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("周") ||
      state.cycleInfo!.displayValue.contains("Week")) {
    pickerData = [
      state.investment.intervalWeek!,
      state.investment.intervalTime!
    ];
  } else if (state.cycleInfo!.displayValue.contains("日") ||
      state.cycleInfo!.displayValue.contains("Day")) {
    pickerData = [state.investment.intervalTime!];
  } else if (state.cycleInfo!.displayValue.contains("小时") ||
      state.cycleInfo!.displayValue.contains("Hour")) {
    pickerData = [state.investment.intervalHour!];
  } else if (state.cycleInfo!.displayValue.contains("分钟") ||
      state.cycleInfo!.displayValue.contains("Minute")) {
    pickerData = [state.investment.intervalMinute!];
  }
  return pickerData;
}

Future<void> _onSelectCoin(
    Action action, Context<InvestmentHandleState> ctx) async {
  var result = await Navigator.of(ctx.context).pushNamed('investmentCoinPage',
      arguments: {
        'currentFiatIndex': ctx.state.selectedCoin,
        'coinInfos': ctx.state.coinlist
      });

  if (result != null) {
    int currentFiatIndex = result as int;
    ctx.state.selectedCoin = currentFiatIndex;
    ctx.state.coinInfo = ctx.state.coinlist[currentFiatIndex];
    print('currentFiatIndex:$currentFiatIndex');
    ctx.dispatch(InvestmentHandleActionCreator.onProSuc());
  }
}

Future<void> _onTextValue(
    Action action, Context<InvestmentHandleState> ctx) async {
  String value = action.payload;
  ctx.state.mount = value;
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorText = "";
    ctx.dispatch(InvestmentHandleActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
    return;
  }
  final RegExp numberRegex = RegExp(r'^(0|[1-9]\d*)(\.\d+)?$');
  if (!numberRegex.hasMatch(value)) {
    ctx.state.errorText = "Please enter a valid number";
    ctx.state.mount = "";
    ctx.dispatch(InvestmentHandleActionCreator.onUpdate());
    ctx.state.focusNode2.requestFocus();
    print("errorTip-_numberRegex:${ctx.state.errorText}");
    return;
  }

  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! > ctx.state.totalCoin) {
      ctx.state.errorText = "Enter number is too large";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvestmentHandleActionCreator.onUpdate());
      ctx.state.focusNode2.requestFocus();
      return;
    }
    if (double.tryParse(value)! < 0) {
      ctx.state.errorText = "Enter number is too small";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvestmentHandleActionCreator.onUpdate());
      ctx.state.focusNode2.requestFocus();
      return;
    }
  }
  ctx.state.errorText = "";
  ctx.state.mount = value;
  ctx.dispatch(InvestmentHandleActionCreator.onUpdate());
  ctx.state.focusNode2.requestFocus();
}

Future<void> _onAddAction(
    Action action, Context<InvestmentHandleState> ctx) async {
  _onAddOrEditAction(action, ctx, true);
}

Future<void> _onEditAction(
    Action action, Context<InvestmentHandleState> ctx) async {
  _onAddOrEditAction(action, ctx, false);
}

_onAddOrEditAction(
    Action action, Context<InvestmentHandleState> ctx, bool isAdd) async {
  final stablecoin = await DefaultStablecoinManager.getCachedOrFallback();
  if (ctx.state.investmentName.isEmpty) {
    showToast("Name can't empty", duration: const Duration(milliseconds: 2000));
    print("_onPressedActionerrorTip0:${ctx.state.investmentName}");
    return;
  }
  if (ctx.state.errorText.isNotEmpty) {
    print("_onPressedActionerrorTip:${ctx.state.errorText}");
    return;
  }
  if (ctx.state.mount.isEmpty) {
    showToast("mount can't empty",
        duration: const Duration(milliseconds: 2000));
    return;
  }

  if (double.tryParse(ctx.state.mount)! < 0) {
    print("_onPressedtryParse-wrong:${ctx.state.errorText}");
    return;
  }
  var smartCardCryptoId = ctx.state.coinInfo!.id;
  var intervalType =
      ctx.state.investment.intervalUnit![ctx.state.selectedCycle].value;
  var intervalExtend1 = "";
  var intervalExtend2 = "";
  var intervalExtend3 = "";
  if (ctx.state.selectInfo1 != null) {
    intervalExtend1 = ctx.state.selectInfo1!.value;
  }
  if (ctx.state.selectInfo2 != null) {
    intervalExtend2 = ctx.state.selectInfo2!.value;
  }
  if (ctx.state.selectInfo3 != null) {
    intervalExtend3 = ctx.state.selectInfo3!.value;
  }
  var parameters = {
    'assetFromAmount': ctx.state.mount,
    'uid': ctx.state.uid,
    'name': ctx.state.investmentName,
    "assetFromType": "CRYPTO",
    "assetFrom": stablecoin,
    "assetToType": "CRYPTO",
    "smartCardCryptoId": smartCardCryptoId,
    "intervalType": intervalType,
    "intervalExtend1": intervalExtend1,
    "intervalExtend2": intervalExtend2,
    "intervalExtend3": intervalExtend3,
  };
  if (isAdd == false) {
    parameters['id'] = ctx.state.id;
  }
  print("parameters1:$parameters");
  var url =
      isAdd ? NetworkAddress.createInvestment : NetworkAddress.updateInvestment;
  HttpManager.getInstance()
      .post(url, null, data: parameters)
      .then((intervalResult) {
    if (intervalResult.isSuccess) {
      if (isAdd) {
        showToast("Create Investment Success",
            duration: const Duration(milliseconds: 2000));
      } else {
        showToast("Update Investment Success",
            duration: const Duration(milliseconds: 2000));
      }

      Navigator.of(ctx.context).pop(true);
    } else {
      showToast(intervalResult.message,
          duration: const Duration(milliseconds: 2000));
    }
  });
}

bool _checkMount(Action action, Context<InvestmentHandleState> ctx) {
  if (ctx.state.investmentName.isEmpty) {
    showToast("Name can't empty", duration: const Duration(milliseconds: 2000));
    print("_onPressedActionerrorTip0:${ctx.state.investmentName}");
    return false;
  }
  if (ctx.state.errorText.isNotEmpty) {
    print("_onPressedActionerrorTip:${ctx.state.errorText}");
    return false;
  }
  if (ctx.state.mount.isEmpty) {
    showToast("mount can't empty",
        duration: const Duration(milliseconds: 2000));
    return false;
  }

  if (double.tryParse(ctx.state.mount)! < 0) {
    print("_onPressedtryParse-wrong:${ctx.state.errorText}");
    return false;
  }
  return true;
}

Future<void> _onOperateAction(
    Action action, Context<InvestmentHandleState> ctx) async {
  var url = "";
  InvestmentActionType type = action.payload;
  if (type == InvestmentActionType.puase) {
    var result = await showDialog(
        context: ctx.context,
        builder: (_) {
          return const ZenggeTextAlertDialog(
            "You are about to pause this investment plan. Do you want to continue? ",
            enableCancel: true,
            confirmText: "Comfirm",
            cancelText: "Cancel",
          );
        });
    if (result != true) {
      return;
    }
  } else if (type == InvestmentActionType.stop) {
    var result = await showDialog(
        context: ctx.context,
        builder: (_) {
          return const ZenggeTextAlertDialog(
            "You are about to terminate this investment plan. Do you want to continue?  ",
            enableCancel: true,
            confirmText: "Comfirm",
            cancelText: "Cancel",
          );
        });
    if (result != true) {
      return;
    }
  }

  if (type == InvestmentActionType.puase) {
    url = NetworkAddress.pauseInvestment;
  } else if (type == InvestmentActionType.stop) {
    url = NetworkAddress.terminatedInvestment;
  } else if (type == InvestmentActionType.resume) {
    url = NetworkAddress.resumeInvestment;
  }
  var parameters = {
    'id': ctx.state.id,
    'uid': ctx.state.uid,
  };

  HttpManager.getInstance()
      .post(url, null, data: parameters)
      .then((intervalResult) {
    if (intervalResult.isSuccess) {
      showToast("Change Investment Success",
          duration: const Duration(milliseconds: 2000));

      Navigator.of(ctx.context).pop(true);
    } else {
      showToast(intervalResult.message,
          duration: const Duration(milliseconds: 2000));
    }
  });
}

Future<void> _onPushHistoryAction(
    Action action, Context<InvestmentHandleState> ctx) async {
  await Navigator.of(ctx.context).pushNamed('investmentHistoryPage',
      arguments: {'uid': ctx.state.uid, 'id': ctx.state.id});
}

Future<void> _onFlowHistory(
    Action action, Context<InvestmentHandleState> ctx) async {
  String cardId = ctx.state.uid;

  Navigator.of(ctx.context).pushNamed('flowHistoryPage', arguments: {
    'uid': cardId,
  });
}
