import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<HdRechargeState>? buildEffect() {
  return combineEffects(<Object, Effect<HdRechargeState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    HdRechargeAction.action: _onAction,
    HdRechargeAction.showNetworks: _onShowNetworkList,
    HdRechargeAction.update: _onUpdate,
    HdRechargeAction.back: _onBack,
  });
}

void _onInit(Action action, Context<HdRechargeState> ctx) {
  // if (info.address != null) {
  ctx.dispatch(HdRechargeActionCreator.onShowNetworks());
  // }
}

void _onBack(Action action, Context<HdRechargeState> ctx) {
  // await Future.delayed(const Duration(seconds: 0));
  Navigator.of(ctx.context).pop();
  //  Navigator.of(ctx.context).pop();
  // }
}

void _onUpdate(Action action, Context<HdRechargeState> ctx) {
  CurrencyInfo info = action.payload;

  if (info.balance != null) {
    print("HdRechargeState_onUpdate0");
    ctx.dispatch(HdRechargeActionCreator.onLoadSuccess(info));
  } else {
    print("HdRechargeState_onUpdate1");
    ctx.dispatch(HdRechargeActionCreator.onShowLoading());
  }
}

Future<void> _onShowNetworkList(
    Action action, Context<HdRechargeState> ctx) async {
  await Future.delayed(const Duration(seconds: 0));
  var languageResource = ctx.state.languageResource!;
  CurrencyInfo info = ctx.state.bigCurrency;
  if (info.networkLists!.length == 1) {
    ctx.state.index = 0;
    final networkInfo = info.networkLists![0];
    if (networkInfo.balance == null || networkInfo.address == null) {
      _showTipView(action, ctx);
      return;
    }
    ctx.dispatch(HdRechargeActionCreator.onUpdate(networkInfo));
    return;
  }
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
                      Text(languageResource.selectCoin),
                      CloseButton(
                        onPressed: () {
                          Navigator.of(ctx.context).pop();
                          Navigator.of(ctx.context).pop();
                        },
                      )
                    ]),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: info.networkLists!.length,
                      itemBuilder: (context, index) {
                        final cardInfo = info.networkLists![index];
                        return GestureDetector(
                            onTap: () {
                              if (cardInfo.balance == null ||
                                  cardInfo.address == null) {
                                _showTipView(action, ctx);
                                return;
                              }
                              ctx.state.index = index;
                              Navigator.of(ctx.context).pop();
                              ctx.dispatch(
                                  HdRechargeActionCreator.onUpdate(cardInfo));
                            },
                            child: _itemWidgetBuild(ctx, context, cardInfo));
                      }),
                )
              ],
            ));
      }));
}

void _showTipView(Action action, Context<HdRechargeState> ctx) async {
  final languageResource = ctx.state.languageResource!;
  await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(
          languageResource.unSupportRecharge,
        );
      });
}

Widget _itemWidgetBuild(
    Context<HdRechargeState> ctx, BuildContext context, CurrencyInfo currency) {
  String coin =
      "${currency.currencyData.id}-${currency.networkName ?? currency.currencyData.networkId.toUpperCase()}";
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

void _onDispose(Action action, Context<HdRechargeState> ctx) {
  print("eeeee");
}

void _onAction(Action action, Context<HdRechargeState> ctx) {}
