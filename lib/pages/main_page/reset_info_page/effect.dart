import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<ResetInfoState>? buildEffect() {
  return combineEffects(<Object, Effect<ResetInfoState>>{
    Lifecycle.initState: _onInit,
    ResetInfoAction.onResetFactorySettings: _onResetFactorySettings,
    ResetInfoAction.onCleanCache: _onCleanCache,
  });
}

void _onInit(Action action, Context<ResetInfoState> ctx) {
  // ctx.dispatch(ResetInfoActionCreator.onLoadCardInfo());
}

void _onResetFactorySettings(Action action, Context<ResetInfoState> ctx) {
  Navigator.of(ctx.context).pushNamed(
    'resetFactorySettingsPage',
    arguments: {
      'cardId': ctx.state.cardInfo.uuid,
      'isPinSet': ctx.state.cardInfo.pinSet,
      'cardNo': ctx.state.cardNo,
    },
  );
}

void _onCleanCache(Action action, Context<ResetInfoState> ctx) {
  Navigator.of(ctx.context).pushNamed(
    'cleanCachePage',
    arguments: {
      'cardId': ctx.state.cardInfo.uuid,
    },
  );
}
