import 'dart:async';
import 'dart:convert';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/runnable/card_common_status_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<DeviceSettingsState>? buildEffect() {
  return combineEffects(<Object, Effect<DeviceSettingsState>>{
    Lifecycle.initState: _onInit,
    DeviceSettingsAction.action: _onAction,
    DeviceSettingsAction.scanClick: _onScanClick,
  });
}

void _onInit(Action action, Context<DeviceSettingsState> ctx) async {
  String? cardUuid = await LocalStorage.getCardUuid();
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardUuid!);
  if (cardInfoJson?.isNotEmpty ?? false) {
    ctx.state.cardInfo = CardInfo.fromJson(json.decode(cardInfoJson!));
    ctx.dispatch(DeviceSettingsActionCreator.onUpdateImage());
  }
}

void _onAction(Action action, Context<DeviceSettingsState> ctx) {}

Future<void> _onScanClick(
    Action action, Context<DeviceSettingsState> ctx) async {
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  if ((cardNo == null || cardNo.isEmpty)) {
    cardNo = ctx.state.cardDetail.cardNo;
  }
  var result = await ScanUtil.chipScanWithRunnable(CardCommonStatusRunnable(),
      checkLock: true, expectedCardId: ctx.state.cardId, cardNo: cardNo);

  if (!result.isSuccess) {
    if (result.message != "Session invalidated by user") {
      if (result.message!.length < 50) {
        await ScanUtil.unlockTip(result, ctx.context, ctx.state.cardId);
      }
    }
    return;
  }

  print("resetInfoPage_pushdata:${result.data}");

  Navigator.of(ctx.context).pushNamed('resetInfoPage', arguments: {
    'cardInfo': result.data,
    'cardNo': cardNo,
    'cardDetail': ctx.state.cardDetail
  });
}
