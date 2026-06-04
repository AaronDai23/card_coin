import 'dart:convert';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/investment_withdrawal.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/store.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/lightning_sign_info.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<InvestmentWithdrawalState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentWithdrawalState>>{
    InvestmentWithdrawalAction.action: _onAction,
    Lifecycle.initState: _onInit,
    InvestmentWithdrawalAction.textValue: _onTextValue,
    InvestmentWithdrawalAction.withdrawal: _onSendClick,
    InvestmentWithdrawalAction.loadData: _onLoadData,
    InvestmentWithdrawalAction.showNetworks: _onShowNetworkList,
    InvestmentWithdrawalAction.pushWalletPage: _onPushWalletClick,
  });
}

Future<void> _onInit(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  ctx.dispatch(InvestmentWithdrawalActionCreator.onLoadData());
}

void _onAction(Action action, Context<InvestmentWithdrawalState> ctx) {}

Future<void> _onLoadData(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  Map<String, dynamic> params = {
    'uid': ctx.state.uid,
    'code': ctx.state.detail!.code
  };
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.investmentPreWithdrawal, null, data: params);
  if (result.isSuccess) {
    if (result.data is String) {
      ctx.dispatch(
          InvestmentWithdrawalActionCreator.onLoadFailure("net data wrong"));
    }

    List<dynamic> list = result.data['cryptos'];
    if (list.isEmpty) {
      var result = await showDialog(
          context: ctx.context,
          builder: (_) {
            return const ZenggeTextAlertDialog(
              "Invest Withdrawal cryptos is Empty,please  init walllet first",
              enableCancel: true,
              confirmText: "Go to Wallet",
              cancelText: "Cancel",
            );
          });
      if (result == true) {
        ctx.dispatch(InvestmentWithdrawalActionCreator.onPushWalletPage());
      } else {
        Navigator.pop(ctx.context);
      }
      return;
    }
    List<InvestmentWithdrawal> investmentList =
        list.map((e) => InvestmentWithdrawal.fromJson(e)).toList();
    var signInfo = LightningSignInfo.fromJson(result.data['signMessage']);
    ctx.state.singInfo = signInfo;
    ctx.state.investmentList = investmentList;
    if (investmentList.isNotEmpty) {
      ctx.state.investment = investmentList[0];
    }
    ctx.dispatch(
        InvestmentWithdrawalActionCreator.onLoadSuccess(ctx.state.detail!));
  } else {
    ctx.dispatch(InvestmentWithdrawalActionCreator.onLoadFailure(""));
  }
}

Future<void> _onShowNetworkList(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  await Future.delayed(const Duration(seconds: 0));
  // InvestmentWithdrawal info = ctx.state.investment!;

  await showModalBottomSheet(
      context: ctx.context,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      builder: ((_) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select Network"),
                      CloseButton(
                        onPressed: () {
                          // Navigator.of(ctx.context).pop();
                          Navigator.of(ctx.context).pop();
                        },
                      )
                    ]),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: ctx.state.investmentList.length,
                      itemBuilder: (context, index) {
                        final cardInfo = ctx.state.investmentList[index];
                        return GestureDetector(
                            onTap: () {
                              // if (cardInfo.balance == null ||
                              //     cardInfo.address == null) {
                              //   _showTipView(action, ctx);
                              //   return;
                              // }
                              ctx.state.investment = cardInfo;
                              Navigator.of(ctx.context).pop();
                              ctx.dispatch(InvestmentWithdrawalActionCreator
                                  .onLoadSuccess(ctx.state.detail!));
                            },
                            child: _itemWidgetBuild(ctx, context, cardInfo));
                      }),
                )
              ],
            ));
      }));
}

Widget _itemWidgetBuild(Context<InvestmentWithdrawalState> ctx,
    BuildContext context, InvestmentWithdrawal currency) {
  String coin = "${currency.code}-${currency.netName}";
  return Card(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              coin,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        )),
  );
}

Future<void> _onTextValue(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  String value = action.payload;
  ctx.state.mount = value;
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorText = "";
    ctx.dispatch(InvestmentWithdrawalActionCreator.onUpdate());
    ctx.state.focusNode.requestFocus();
    return;
  }
  //  RegExp numberRegex = (!RegExp(r'^[-+]?(0|[1-9]\d*)(\.\d+)?$').hasMatch(value))
  if (!RegExp(r'^[-+]?(0|[1-9]\d*)(\.\d+)?$').hasMatch(value)) {
    ctx.state.errorText = "Please enter a valid number";
    ctx.state.mount = "";
    ctx.dispatch(InvestmentWithdrawalActionCreator.onUpdate());
    ctx.state.focusNode.requestFocus();
    print("errorTip-_numberRegex:$value");
    return;
  }

  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! >
        double.tryParse(ctx.state.detail!.balance!)!) {
      ctx.state.errorText = "Enter number is too large";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvestmentWithdrawalActionCreator.onUpdate());
      ctx.state.focusNode.requestFocus();
      return;
    }
    if (double.tryParse(value)! < 0) {
      ctx.state.errorText = "Enter number is too small";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(InvestmentWithdrawalActionCreator.onUpdate());
      ctx.state.focusNode.requestFocus();
      return;
    }
  }
  ctx.state.errorText = "";
  ctx.state.mount = value;
  ctx.dispatch(InvestmentWithdrawalActionCreator.onUpdate());
  ctx.state.focusNode.requestFocus();
}

Future<void> _onSendClick(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  // String keyBTCInit = "${uid}_btc_init";
  // String? initSucStatus = await LocalStorage.getString(keyBTCInit);
  GlobalState globalState = GlobalStore.store.getState();

  // globalState.isInitBTC = isInitBTC == '1' ? true : false;
  print("globalState.isInitBTC:${globalState.isInitBTC}");
  if (globalState.isInitBTC == null || globalState.isInitBTC == false) {
    var result = await showDialog(
        context: ctx.context,
        builder: (_) {
          return const ZenggeTextAlertDialog(
            "Wallet not init finish,please full initialization",
            enableCancel: true,
            confirmText: "Go to Wallet",
            cancelText: "Cancel",
          );
        });
    if (result == true) {
      ctx.dispatch(InvestmentWithdrawalActionCreator.onPushWalletPage());
    }
    return;
  }

  // print("btc-initstatus9999:${initSucStatus}");

  final pr = ProgressDialog(ctx.context);
  await pr.show();

  var signInfo = ctx.state.singInfo;
  String signedHex;
  try {
    signedHex = await BlockchainPlatform.instance
        .signLightning(signInfo!.signMessage, true);
  } catch (error) {
    pr.hide();
    if (error is! PlatformException) {
      showToast(error.toString());
    }

    return;
  }

  var publicKey = await BlockchainPlatform.instance.getBitcoinPublicKey();

  String mount = ctx.state.amountController.text;

  final params = {
    'uid': ctx.state.uid,
    'signId': signInfo.signId,
    'publicKey': publicKey,
    'signResult': signedHex,
    'amount': double.tryParse(mount),
    'smartCardCryptoId': ctx.state.investment!.id!,
  };

  var paymentResult = await HttpManager.getInstance()
      .post(NetworkAddress.investmentWithdrawal, null, data: params);
  pr.hide();
  if (paymentResult.isSuccess) {
    await showDialog(
        context: ctx.context,
        builder: (context) {
          return const ZenggeTextAlertDialog('Send successfull！');
        });

    Navigator.of(ctx.context).pop();
  } else {
    pr.hide();
    showToast(paymentResult.message);
  }
}

Future<void> _onPushWalletClick(
    Action action, Context<InvestmentWithdrawalState> ctx) async {
  String cardId = ctx.state.uid;

  ///获取卡片信息缓存
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardId);
  if (cardInfoJson?.isNotEmpty ?? false) {
    ///根据设备uuid初始化scanResponse,如果失败代表没有本地没有扫卡缓存数据，需要重新扫卡
    var success = await BlockchainPlatform.instance.initScanResponse(cardId);
    if (success) {
      var cardInfo = CardInfo.fromJson(json.decode(cardInfoJson!));
      Navigator.of(ctx.context).pushNamed('cardWalletListPage',
          arguments: {'cardInfo': cardInfo, 'needShowInitStatus': true});
      return;
    }
  }
  Navigator.of(ctx.context).pushNamed('scanWalletPage',
      arguments: {'cardId': cardId, 'needShowInitStatus': true});
}
