import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<InvestmentCoinState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentCoinState>>{
    Lifecycle.initState: _onInit,
    InvestmentCoinAction.selected: _onSelectedAction,
  });
}

Future<void> _onInit(Action action, Context<InvestmentCoinState> ctx) async {
  ctx.dispatch(InvestmentCoinActionCreator.onUpdateList(ctx.state.fiats));
}

Future<void> _onSelectedAction(
    Action action, Context<InvestmentCoinState> ctx) async {
  ctx.state.currentFiatIndex = action.payload;
  Navigator.of(ctx.context).pop(ctx.state.currentFiatIndex);
}
