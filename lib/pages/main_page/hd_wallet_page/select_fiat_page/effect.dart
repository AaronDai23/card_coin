import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<SelectFiatState>? buildEffect() {
  return combineEffects(<Object, Effect<SelectFiatState>>{
    Lifecycle.initState: _onInit,
    SelectFiatAction.selected: _onSelectedAction,
  });
}

Future<void> _onInit(Action action, Context<SelectFiatState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.geCurrencys);
  List<FiatInfo> fiats = [];
  if (result.isSuccess) {
    if (result.data != null) {
      List list = result.data;
      fiats = list.map((e) => FiatInfo.fromJson(e)).toList();
      if (fiats.indexWhere(
              (element) => element.symbol == ctx.state.currentFiat.symbol) ==
          -1) {
        fiats.add(ctx.state.currentFiat);
      }
      if (fiats.indexWhere((element) => element.symbol == 'USDT') == -1) {
        fiats.add(FiatInfo(
            symbol: 'USDT',
            imageUrl: '',
            name: "USDT",
            currentPrice: "1.00",
            scale: '2',
            currency: ''));
      }
    }
  } else {}
  if (fiats.isEmpty) {
    fiats.add(ctx.state.currentFiat);
  }
  ctx.dispatch(SelectFiatActionCreator.onUpdateList(fiats));
}

void _onSelectedAction(Action action, Context<SelectFiatState> ctx) {
  Navigator.of(ctx.context).pop(action.payload);
}
