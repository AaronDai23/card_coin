import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<PinCodeInfoState>? buildEffect() {
  return combineEffects(<Object, Effect<PinCodeInfoState>>{
    PinCodeInfoAction.setPinCode: _onSetPinCode,
    PinCodeInfoAction.cancelPinCode: _onCancelPinCode,
  });
}

Future<void> _onSetPinCode(Action action, Context<PinCodeInfoState> ctx) async {
  var result = await Navigator.of(ctx.context).pushNamed('setPinCodePage',
      arguments: {
        'pinCodeInfo': ctx.state.pinCodeInfo,
        'cardId': ctx.state.cardId
      });
  if (result == true) {
    Navigator.of(ctx.context).pop();
    // ctx.dispatch(PinCodeInfoActionCreator.onUpdatePinCodeInfo(
    //     ctx.state.pinCodeInfo.copyWith(isOpen: true)));
  }
  // ScanUtil.scanCard(ctx.context, runnable: runnable)
}

Future<void> _onCancelPinCode(
    Action action, Context<PinCodeInfoState> ctx) async {
  var result = await Navigator.of(ctx.context)
      .pushNamed('cancelPinCodePage', arguments: {'cardId': ctx.state.cardId});
  if (result == true) {
    Navigator.of(ctx.context).pop();

    // ctx.dispatch(PinCodeInfoActionCreator.onUpdatePinCodeInfo(
    //     ctx.state.pinCodeInfo.copyWith(isOpen: false)));
  }
  // ScanUtil.scanCard(ctx.context, runnable: runnable)
}
