import 'dart:async';
import 'dart:io';

import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_service/keyboard_service.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Effect<InvestmentActiveCardDialogState>? buildEffect() {
  return combineEffects(<Object, Effect<InvestmentActiveCardDialogState>>{
    InvestmentActiveCardDialogAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    Lifecycle.didChangeAppLifecycleState: _onChangeAppLifecycle,
    InvestmentActiveCardDialogAction.startScan: _onStartScan,
    InvestmentActiveCardDialogAction.sendResetCommand: _onSendResetCommand,
    InvestmentActiveCardDialogAction.pwdBtnClick: _onPwdBtnClick,
  });
}

void _onAction(Action action, Context<InvestmentActiveCardDialogState> ctx) {}

Future<void> _onDispose(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  NfcManager.instance.stopSession();
  ctx.state.timer?.cancel();
  BlockchainPlatform.instance.resetNfcReaderMode();
}

Future<void> _onChangeAppLifecycle(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  AppLifecycleState lifecycleState = action.payload;
  if (lifecycleState == AppLifecycleState.resumed) {
    Navigator.of(ctx.context).pop();
  }
}

Future<void> _onPwdBtnClick(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  String pinCodeStr = ctx.state.pwdController.text;

  var languageResource = ctx.state.languageResource!;
  if (pinCodeStr.isEmpty) {
    showToast(languageResource.enterPukCode);
    return;
  }

  if (pinCodeStr.length != 6) {
    showToast(languageResource.pinCodeDigitsTips);
    return;
  }

  if (!StringUtils.isNumeric(pinCodeStr)) {
    showToast(languageResource.pinCodeNumTips);
    return;
  }

  KeyboardService.dismiss();
  if (Platform.isIOS) {
    Navigator.pop(ctx.context, ScanResponse(true, data: pinCodeStr));
    return;
  }
  ctx.dispatch(
      InvestmentActiveCardDialogActionCreator.onUpdateShowInput(false));
}

Future<void> _onSendResetCommand(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  String readerManager = action.payload;
  try {
    // List<int>? pinCode;
    // if (pwd.isNotEmpty) {
    //   pinCode = [];
    //   for (int i = 0; i < pwd.length; i++) {
    //     pinCode.add(int.parse(pwd[i]));
    //   }
    // }
    // var runnable = ResetCardRunnable(pinCode: pinCode);
    // var response = await runnable.run(ctx.context, readerManager);
    // if (response.isSuccess) {
    int count = ctx.state.currentCount;
    print('count :$count');
    ctx.state.timer = Timer(const Duration(milliseconds: 1000), () async {
      ctx.dispatch(InvestmentActiveCardDialogActionCreator.onSendResetCommand(
          readerManager));
      ctx.state.currentCount += 1;
    });
    if (count == 5) {
      // count = 0;
      ctx.dispatch(
          InvestmentActiveCardDialogActionCreator.onUpdateCount(count));
      ctx.state.completer?.complete(ScanResponse(true));
    } else {
      ctx.dispatch(
          InvestmentActiveCardDialogActionCreator.onUpdateCount(count));
    }

    // } else {
    //   if (response.sw1 == 0xAA && response.sw2 == 0x30) {
    // ctx.state.completer?.complete(ScanResponse(true));
    //   } else {
    //     print('reset error');
    //     ctx.state.completer?.complete(response);
    //   }
    // }
  } catch (error) {
    print('runnable error:$error');
    if (error is PlatformException) {
      ctx.state.pwdController.clear();
      ctx.dispatch(
          InvestmentActiveCardDialogActionCreator.onUpdateScanned(false));
      return;
    }
    ctx.state.completer
        ?.complete(ScanResponse(false, message: error.toString()));
  }
}

Future<void> _onInit(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  ctx.dispatch(InvestmentActiveCardDialogActionCreator.onStartScan());
}

Future<void> _onStartScan(
    Action action, Context<InvestmentActiveCardDialogState> ctx) async {
  if (Platform.isIOS) {
    if (ctx.state.showPwdInput) {
      return;
    }

    if (ctx.state.isPinSet && ctx.state.pwdController.text.isEmpty) {
      ctx.state.completer = Completer();
      ctx.dispatch(
          InvestmentActiveCardDialogActionCreator.onUpdateShowInput(true));
      await ctx.state.completer?.future;

      return;
    }
  }

  // NfcManager.instance.startSession(
  //   pollingOptions: {
  //     NfcPollingOption.iso14443,
  //     NfcPollingOption.iso15693,
  //   },
  //   alertMessage:
  //       'Hold your card to the upper back of your phone to activate it.Hold the card there until 15 seconds!',
  //   onDiscovered: (NfcTag tag) async {
  //     var isoDep = null;
  //     bool canDo = false;

  //     if (tag.data.keys.contains('isodep')) {
  //       isoDep = IsoDep.from(tag);
  //       canDo = true;
  //     }

  //     if (isoDep != null) {
  // final readerManager = IsoDepReaderManager(isoDep);
  // if (readerManager.cardId != ctx.state.cardId) {
  //   var languageResource = ctx.state.languageResource!;
  //   Navigator.pop(ctx.context,
  //       ScanResponse(false, message: languageResource.sameDeviceTips));
  //   return;
  // }

  // if (ctx.state.showPwdInput) {
  //   return;
  // }

  // if (ctx.state.isPinSet && ctx.state.pwdController.text.isEmpty) {
  //   ctx.dispatch(
  //       InvestmentActiveCardDialogActionCreator.onUpdateShowInput(true));
  //   return;
  // }

  ctx.state.completer = Completer();
  ctx.dispatch(InvestmentActiveCardDialogActionCreator.onUpdateScanned(true));
  ctx.dispatch(InvestmentActiveCardDialogActionCreator.onSendResetCommand(
      "readerManager"));
  var scanResponse = await ctx.state.completer?.future;
  Navigator.pop(ctx.context, scanResponse);
}
