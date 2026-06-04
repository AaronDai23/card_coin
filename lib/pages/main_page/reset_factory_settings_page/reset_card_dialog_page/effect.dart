import 'dart:async';
import 'dart:io';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/managers/isodep_reader_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/runnable/reset_card_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import 'action.dart';
import 'state.dart';

Effect<ResetCardDialogState>? buildEffect() {
  return combineEffects(<Object, Effect<ResetCardDialogState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    Lifecycle.didChangeAppLifecycleState: _onChangeAppLifecycle,
    ResetCardDialogAction.startScan: _onStartScan,
    ResetCardDialogAction.sendResetCommand: _onSendResetCommand,
    ResetCardDialogAction.pwdBtnClick: _onPwdBtnClick,
  });
}

Future<void> _onDispose(
    Action action, Context<ResetCardDialogState> ctx) async {
  NfcManager.instance.stopSession();
  ctx.state.timer?.cancel();
  BlockchainPlatform.instance.resetNfcReaderMode();
}

Future<void> _onChangeAppLifecycle(
    Action action, Context<ResetCardDialogState> ctx) async {
  AppLifecycleState lifecycleState = action.payload;
  if (lifecycleState == AppLifecycleState.resumed) {
    Navigator.of(ctx.context).pop();
  }
}

Future<void> _onPwdBtnClick(
    Action action, Context<ResetCardDialogState> ctx) async {
  // String pinCodeStr = ctx.state.pwdController.text;
  // if (pinCodeStr.isEmpty) {
  //   showToast(languageResource.enterPukCode);
  //   return;
  // }

  // if (pinCodeStr.length != 6) {
  //   showToast(languageResource.pinCodeDigitsTips);
  //   return;
  // }

  // if (!StringUtils.isNumeric(pinCodeStr)) {
  //   showToast(languageResource.pinCodeNumTips);
  //   return;
  // }

  // KeyboardService.dismiss();
  // if (Platform.isIOS) {
  //   Navigator.pop(ctx.context, ScanResponse(true, data: pinCodeStr));
  //   return;
  // }
  ctx.dispatch(ResetCardDialogActionCreator.onUpdateShowInput(false));
}

Future<void> _onSendResetCommand(
    Action action, Context<ResetCardDialogState> ctx) async {
  IsoDepReaderManager readerManager = action.payload;
  try {
    String? pwd = ctx.state.pwdText;
    List<int>? pinCode;
    if (pwd.isNotEmpty) {
      pinCode = [];
      for (int i = 0; i < pwd.length; i++) {
        pinCode.add(int.parse(pwd[i]));
      }
    }
    var runnable = ResetCardRunnable(pinCode: pinCode);
    var response = await runnable.run(ctx.context, readerManager);
    if (response.isSuccess) {
      int count = response.data!;
      print('count :$count');
      ctx.state.timer = Timer(const Duration(milliseconds: 1000), () async {
        ctx.dispatch(
            ResetCardDialogActionCreator.onSendResetCommand(readerManager));
      });
      if (count == 10) {
        count = 0;
      }

      ctx.dispatch(ResetCardDialogActionCreator.onUpdateCount(count));
    } else {
      if (response.sw1 == 0xAA && response.sw2 == 0x30) {
        ctx.state.completer?.complete(ScanResponse(true));
      } else {
        print('reset error');
        ctx.state.completer?.complete(response);
      }
    }
  } catch (error) {
    print('runnable error:$error');
    if (error is PlatformException) {
      // ctx.state.pwdController.clear();
      ctx.dispatch(ResetCardDialogActionCreator.onUpdateScanned(false));
      return;
    }
    ctx.state.completer
        ?.complete(ScanResponse(false, message: error.toString()));
  }
}

Future<void> _onInit(Action action, Context<ResetCardDialogState> ctx) async {
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  if (cardNo == null || cardNo.isEmpty) {
    cardNo = ctx.state.cardNo;
  }
  ctx.dispatch(ResetCardDialogActionCreator.onUpdateCardNo(cardNo ?? ""));
  ctx.dispatch(ResetCardDialogActionCreator.onStartScan());
}

Future<void> _onStartScan(
    Action action, Context<ResetCardDialogState> ctx) async {
  if (Platform.isIOS) {
    if (ctx.state.showPwdInput) {
      return;
    }

    if (ctx.state.isPinSet && ctx.state.pwdText.isEmpty) {
      ctx.state.completer = Completer();
      ctx.dispatch(ResetCardDialogActionCreator.onUpdateShowInput(true));
      await ctx.state.completer?.future;

      return;
    }
  }

  NfcManager.instance.startSession(
    pollingOptions: {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
    },
    alertMessage:
        'Hold your card near iPhone camera on upper back, until you see a ✅',
    onDiscovered: (NfcTag tag) async {
      IsoDep? isoDep;

      if (tag.data.keys.contains('isodep')) {
        isoDep = IsoDep.from(tag);
      }

      if (isoDep != null) {
        final readerManager = IsoDepReaderManager(isoDep);
        if (readerManager.cardId != ctx.state.cardId) {
          var languageResource = ctx.state.languageResource!;
          Navigator.pop(ctx.context,
              ScanResponse(false, message: languageResource.sameDeviceTips));
          return;
        }

        if (ctx.state.showPwdInput) {
          return;
        }

        if (ctx.state.isPinSet && ctx.state.pwdText.isEmpty) {
          ctx.dispatch(ResetCardDialogActionCreator.onUpdateShowInput(true));
          return;
        }

        ctx.state.completer = Completer();
        ctx.dispatch(ResetCardDialogActionCreator.onUpdateScanned(true));
        ctx.dispatch(
            ResetCardDialogActionCreator.onSendResetCommand(readerManager));
        var scanResponse = await ctx.state.completer?.future;
        Navigator.pop(ctx.context, scanResponse);
      } else {
        Navigator.pop(ctx.context,
            ScanResponse(false, message: "The card can't get IsoDep manager"));
      }
    },
    onError: (NfcError error) async {
      Navigator.of(ctx.context)
          .pop(ScanResponse(false, message: error.toString()));
    },
  );
}
