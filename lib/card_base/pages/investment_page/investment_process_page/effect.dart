import 'dart:async';

import 'package:card_coin/app.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/app_config.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentProcessState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentProcessState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    // InvestmentProcessAction.action: _onAction,
    InvestmentProcessAction.scanCard: _onScanCard,
    InvestmentProcessAction.flowProgress: _onNewFlowProgressData,
    // InvestmentProcessAction.activateCard: _onActiveCard,
    // InvestmentProcessAction.preActivateCard: _onPreActiveCard,
    // InvestmentProcessAction.preApprovalDCA: _onPreProActiveCard,
    InvestmentProcessAction.loadDefaultCurrency: _onLoadDefaultCurrency,
    // InvestmentProcessAction.approvalDCA: _onApprovalActiveCard,
    InvestmentProcessAction.signDCA: _onSignDCA,
    InvestmentProcessAction.backClick: _onBackAction,
  });
}

void _onInit(Action action, Context<InvestmentProcessState> ctx) {
  ctx.dispatch(InvestmentProcessActionCreator.onLoadDefaultCurrency());
}

void _onDispose(Action action, Context<InvestmentProcessState> ctx) {
  if (ctx.state.timer != null) {
    ctx.state.timer!.cancel();
  }
}

Future<void> _onBackAction(
    Action action, Context<InvestmentProcessState> ctx) async {
  Navigator.of(ctx.context).pop(true);
  ctx.broadcast(InvestmentProcessActionCreator.onNotificationBackClick());
}

Future<void> _onLoadDefaultCurrency(
    Action action, Context<InvestmentProcessState> ctx) async {
  List list = [];
  var isProApp = AppConfig.of(navigatorKey.currentContext!).isProApp;
  if (isProApp) {
    final parameters = <String, dynamic>{'asset': true};
    final result = await HttpManager.getInstance()
        .get(NetworkAddress.allcryptoListUrl, queryParameters: parameters);
    if (result.isSuccess) {
      list = (result.data as List);
    } else {
      showToast(result.message);
      return;
    }
  } else {
    var dict = {
      'page': '1',
      'row': 20,
      'uid': ctx.state.uid,
      'isDefault': true
    };

    final result = await HttpManager.getInstance()
        .get(NetworkAddress.cryptoListUrl, queryParameters: dict);
    if (result.isSuccess) {
      print('22222result.data:${result.data}');
      list = (result.data['rows'] as List);
    } else {
      showToast(result.message);
      return;
    }
  }

  List<CurrencyInfo> currencyList = [];
  List<CoinMessage> tokens =
      list.map((e) => CoinMessage.fromJson(e)).toList().cast<CoinMessage>();

  for (final token in tokens) {
    final list = token.networks.map((e) {
      String networkId = e.networkId;
      if (networkId.contains('ETH') && e.testnet) {
        networkId = "${e.networkId.toUpperCase()}/test";
      } else {
        networkId = networkId.toUpperCase();
      }
      return CurrencyInfo(
          imageUrl: token.imageUrl,
          networkName: e.networkName,
          isTest: e.testnet,
          currencyData: CurrencyData(
              token.id, e.imageUrl, token.name, token.symbol, networkId,
              decimals: e.decimalCount, contractAddress: e.contractAddress));
    });
    currencyList.addAll(list);
  }

  if (currencyList.isEmpty) {
    currencyList.addAll([
      CurrencyInfo(
          imageUrl: '',
          networkName: 'Bitcoin',
          currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC')),
    ]);
  }
  ctx.state.defaultCurrencyList = currencyList;

  ctx.state.timer =
      Timer.periodic(Duration(seconds: ctx.state.commonSeconds), (timer) {
    if (ctx.state.timer != null) {
      ctx.dispatch(InvestmentProcessActionCreator.onFlowProgressAction());
    }
  });
  ctx.dispatch(InvestmentProcessActionCreator.onFlowProgressAction());
}

// 新流程

Future<void> _onNewFlowProgressData(
    Action action, Context<InvestmentProcessState> ctx) async {
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.flowProgress, null, data: {'uid': ctx.state.uid});
  if (result.isSuccess) {
    if (result.data != null) {
      List<dynamic> list = result.data;

      List<FlowProgressNewInfo> steps =
          list.map((e) => FlowProgressNewInfo.fromJson(e)).toList();

      if (ctx.state.fromeIndex == 1) {
        int successCount = 0;
        steps.insert(0, ctx.state.steps[0]);
        ctx.state.steps = steps;
        var isFirst = true;
        for (var i = 0; i < steps.length; i++) {
          var step = steps[i];
          if (step.transactionResult == 'SUCCESS') {
            successCount++;
          }
        }

        // 成功的次数已经是除
        if (successCount == steps.length - 1) {
          var lastStep = steps.last;
          if (lastStep.transactionResult == 'SUCCESS') {
            ctx.state.timer?.cancel();
            ctx.state.timer = null;
            Future.delayed(const Duration(seconds: 2), () {
              ctx.state.timer?.cancel();
              ctx.state.timer = null;
              // 2秒后执行的代码
              print('2秒后执行的操作');
              if (ctx.state.isSingle!) {
                Navigator.of(ctx.context).popAndPushNamed(
                    'investmentSingleDetailPage',
                    arguments: {'uid': ctx.state.uid, 'id': ctx.state.id});
              } else {
                Navigator.of(ctx.context).popAndPushNamed('investmentPage',
                    arguments: {
                      'uid': ctx.state.uid,
                      'investmentConfig': ctx.state.investmentConfig
                    });
              }
            });
          }
          return;
        }
        for (var i = 0; i < steps.length; i++) {
          var step = steps[i];
          if (step.transactionResult == 'CREATED') {
            if (isFirst) {
              ctx.state.progressSetp = i;
              isFirst = false;
            }
          } else if (step.transactionResult == 'PROCESSING') {
            ctx.state.progressSetp = i;
            break;
          } else if (step.transactionResult == 'SUCCESS') {
            successCount++;
            continue;
          } else if (step.transactionResult == 'FAILED' ||
              step.transactionResult == 'EXPIRED') {
            ctx.state.isShowWarning = true;
          }
        }
        print(
            "_onNewFlowProgressData_step:${ctx.state.progressSetp},steps:${ctx.state.steps}");

        ctx.dispatch(
            InvestmentProcessActionCreator.onUpdateCardAction(ctx.state.steps));
        if (ctx.state.isShowWarning) {
          var result = await showDialog(
              context: ctx.context,
              builder: (_) {
                return const ZenggeTextAlertDialog(
                  'activing step has happen wrong, please connect sales to check',
                  enableCancel: false,
                  confirmText: "Confirm",
                  cancelText: "",
                );
              });
          if (result == true) {
            ctx.dispatch(InvestmentProcessActionCreator.onBackClick());
            return;
          }
        }

        // 成功的次数已经是除
        if (successCount == steps.length - 2 ||
            ctx.state.progressSetp == steps.length - 1) {
          var lastStep = steps.last;
          if (lastStep.transactionResult == 'SUCCESS') {
            ctx.state.timer?.cancel();
            ctx.state.timer = null;
            Future.delayed(const Duration(seconds: 2), () {
              ctx.state.timer?.cancel();
              ctx.state.timer = null;
              // 2秒后执行的代码
              print('2秒后执行的操作');
              if (ctx.state.isSingle!) {
                Navigator.of(ctx.context).popAndPushNamed(
                    'investmentSingleDetailPage',
                    arguments: {'uid': ctx.state.uid, 'id': ctx.state.id});
              } else {
                Navigator.of(ctx.context).popAndPushNamed('investmentPage',
                    arguments: {
                      'uid': ctx.state.uid,
                      'investmentConfig': ctx.state.investmentConfig
                    });
              }
            });
          }
        }
      } else {
        ctx.state.steps = steps;
        var isFirst = true;
        for (var i = 0; i < steps.length; i++) {
          var step = steps[i];
          if (step.transactionResult == 'CREATED') {
            if (isFirst) {
              ctx.state.progressSetp = i;
              isFirst = false;
            }
          } else if (step.transactionResult == 'PROCESSING') {
            ctx.state.progressSetp = i;
            break;
          } else if (step.transactionResult == 'SUCCESS') {
            continue;
          } else if (step.transactionResult == 'FAILED' ||
              step.transactionResult == 'EXPIRED') {
            ctx.state.isShowWarning = true;
          }
        }
        print(
            "_onNewFlowProgressData_step:${ctx.state.progressSetp},steps:${ctx.state.steps}");

        ctx.dispatch(
            InvestmentProcessActionCreator.onUpdateCardAction(ctx.state.steps));
        if (ctx.state.isShowWarning) {
          var result = await showDialog(
              context: ctx.context,
              builder: (_) {
                return const ZenggeTextAlertDialog(
                  'activing step has happen wrong, please connect sales to check',
                  enableCancel: false,
                  confirmText: "Confirm",
                  cancelText: "",
                );
              });
          if (result == true) {
            ctx.dispatch(InvestmentProcessActionCreator.onBackClick());
            return;
          }
        }

        if (ctx.state.progressSetp == steps.length - 1) {
          var lastStep = steps.last;
          if (lastStep.transactionResult == 'SUCCESS') {
            ctx.state.timer?.cancel();
            ctx.state.timer = null;
            Future.delayed(const Duration(seconds: 2), () {
              ctx.state.timer?.cancel();
              ctx.state.timer = null;
              // 2秒后执行的代码
              print('2秒后执行的操作');
              if (ctx.state.isSingle!) {
                Navigator.of(ctx.context)
                    .popAndPushNamed('investmentSingleDetailPage', arguments: {
                  'uid': ctx.state.uid,
                  'id': lastStep.investmentId
                });
              } else {
                Navigator.of(ctx.context).popAndPushNamed('investmentPage',
                    arguments: {
                      'uid': ctx.state.uid,
                      'investmentConfig': ctx.state.investmentConfig
                    });
              }
            });
          }
        }
      }
    }
  }
}

Future<void> _onSignDCA(
    Action action, Context<InvestmentProcessState> ctx) async {
  var newInfo = ctx.state.steps[ctx.state.progressSetp];
  if (newInfo.transactionResult == 'PROCESSING') {
    showToast(
        'current step ${newInfo.transactionType} is already being in activite processing, please wait');
    return;
  }

  if (newInfo.signMessage!.signMessage == null ||
      newInfo.signMessage!.signMessage!.isEmpty) {
    showToast('current step signMessage is null or empty');
    return;
  }
  // FlowProgressNewInfo

  String signReslut = "";
  try {
    print(
        "cardMessage_index:activedSignMessage:${newInfo.signMessage!.signMessage}");
    signReslut = await BlockchainPlatform.instance
        .signLightning(newInfo.signMessage!.signMessage!, false);
  } catch (error) {
    if (error is PlatformException && error.message == 'WrongCardNumber') {
      showToast('WrongCardNumber');
      return;
    }

    if (error is PlatformException &&
        error.message!.contains("channel-error")) {
      showToast(
          'Current network is unstable. Please check your network and try again later.');
      return;
    }
    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }
    showToast(error.toString());
    return;
  }
  var publicKey = "";

  if (ctx.state.assetFrom != null &&
      ctx.state.assetFrom!.toUpperCase().contains('BTC')) {
    publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();
  } else {
    publicKey = await BlockchainPlatform.instance.getEthPublicKey();
  }

  var data = <String, dynamic>{
    'flowId': newInfo.flowId,
    'flowItemId': newInfo.flowItemId,
    'uid': ctx.state.uid,
    'signId': newInfo.signMessage!.signId,
    'publicKey': publicKey,
    'signResult': signReslut,
  };
  print(
      "_onApprovalActiveCard:${newInfo.signMessage!.signId}, signresult:$signReslut");

  print('investmentActivation:data:${data.toString()}');

  List<FlowProgressNewInfo> steps = ctx.state.steps;

  FlowProgressNewInfo step2 = steps[ctx.state.progressSetp];
  step2.transactionResult = 'PROCESSING';
  steps[ctx.state.progressSetp] = step2;
  ctx.dispatch(
      InvestmentProcessActionCreator.onUpdateCardAction(ctx.state.steps));
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.signDCA, null, data: data);
  print('investmentasignDCA result:${result.isSuccess}');

  ctx.dispatch(InvestmentProcessActionCreator.onFlowProgressAction());
  if (result.isSuccess) {
  } else {
    showToast(result.message);
  }
}

Future<void> _onScanCard(
    Action action, Context<InvestmentProcessState> ctx) async {
  String? cardNo = await LocalStorage.getCardNo(ctx.state.uid);

  List<FlowProgressNewInfo> steps = ctx.state.steps;
  FlowProgressNewInfo step2 = steps[ctx.state.progressSetp];

  if (step2.transactionResult == 'PROCESSING') {
    showToast('Card is already being in activite processing');
    return;
  }
  if (ctx.state.fromeIndex == 1 &&
      step2.transactionType == 'INITIALIZATION' &&
      step2.transactionResult == 'CREATED') {
    step2.transactionResult = 'PROCESSING';
    steps[0] = step2;
  }

  try {
    print("cardMessage_index");
    await BlockchainPlatform.instance.scanCardAndDerive(
        ctx.state.defaultCurrencyList, '',
        cardId: ctx.state.uid, cardNo: cardNo);
    step2.transactionResult = 'SUCCESS';
    steps[0] = step2;

    var isFirst = true;
    for (var i = 0; i < steps.length; i++) {
      var step = steps[i];
      if (step.transactionResult == 'CREATED') {
        if (isFirst) {
          ctx.state.progressSetp = i;
          isFirst = false;
        }
      } else if (step.transactionResult == 'SUCCESS') {
        continue;
      } else if (step.transactionResult == 'FAILED' ||
          step.transactionResult == 'EXPIRED') {
        ctx.state.isShowWarning = true;
      }
    }

    ctx.dispatch(
        InvestmentProcessActionCreator.onUpdateCardAction(ctx.state.steps));
  } catch (error) {
    step2.transactionResult = 'CREATED';
    steps[0] = step2;
    ctx.dispatch(
        InvestmentProcessActionCreator.onUpdateCardAction(ctx.state.steps));
    if (error is PlatformException && error.message == 'WrongCardNumber') {
      return;
    }

    if (error.toString().contains('UserCancelled')) {
      showToast('User Cancelled the scan');
      return;
    }

    String errorToString = error.toString();
    if (errorToString.isNotEmpty && errorToString.length < 100) {
      showToast(errorToString);
    }
    return;
  }
}
