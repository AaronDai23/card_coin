import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<HdRechargeMainState>? buildEffect() {
  return combineEffects(<Object, Effect<HdRechargeMainState>>{
    Lifecycle.initState: _onInit,
    HdRechargeMainAction.action: _onAction,
  });
}

Future<void> _onInit(Action action, Context<HdRechargeMainState> ctx) async {
  final TickerProvider tickerProvider = ctx.stfState as TickerProvider;
  var controller =
      TabController(vsync: tickerProvider, length: ctx.state.tabList.length);
  controller.addListener(() {
    print('tab changed:${controller.index}');
  });
  ctx.state.tabController = controller;
  // ctx.dispatch(HdRechargeMainActionCreator.onLoadBalance());
}

void _onAction(Action action, Context<HdRechargeMainState> ctx) {}
