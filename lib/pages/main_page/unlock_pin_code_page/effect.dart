import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';

import '../../../utils/runnable/unlock_card_runnable.dart';
import '../../../utils/scan_util.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<UnlockPinCodeState>? buildEffect() {
  return combineEffects(<Object, Effect<UnlockPinCodeState>>{
    UnlockPinCodeAction.confirmClick: _onConfirmClick,
  });
}

Future<void> _onConfirmClick(
    Action action, Context<UnlockPinCodeState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  String pinCodeStr = ctx.state.pinCodeController.text;
  String pukCodeStr = ctx.state.pukCodeController.text;
  if (pinCodeStr.isNotEmpty && pukCodeStr.isNotEmpty) {
    List<int> pinCode = [];

    if (!StringUtils.isNumeric(pinCodeStr)) {
      showToast(languageResource.pinCodeNumTips);
      return;
    }

    for (int i = 0; i < pinCodeStr.length; i++) {
      pinCode.add(int.parse(pinCodeStr[i]));
    }

    if (pukCodeStr.length != 8) {
      showToast(languageResource.inputErrorPukCode);
      return;
    }

    if (!StringUtils.isNumeric(pukCodeStr)) {
      showToast(languageResource.pukCodeDigitsTips);
      return;
    }

    List<int> pukCode = [];
    for (int i = 0; i < pukCodeStr.length; i++) {
      pukCode.add(int.parse(pukCodeStr[i]));
    }
    // Uint8List pukCode;
    // try {
    //   pukCode = HexUtils.hexStringToUint8List(pukCodeStr);
    // } catch (error) {
    //   showToast(languageResource.incorrectPukCode);
    //   return;
    // }
    String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
    var response = await ScanUtil.chipScanWithRunnable(
        UnlockCardRunnable(pukCode: pukCode, pinCode: pinCode),
        checkLock: true,
        expectedCardId: ctx.state.cardId,
        cardNo: cardNo);
    if (response.isSuccess) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(languageResource.unlockSuccess);
          });
      Navigator.of(ctx.context).pop(true);
    } else {
      print(response.message);
      if (response.message != "Session invalidated by user" &&
          response.message != "Session invalidated unexpectedly") {
        await ScanUtil.unlockTip(response, ctx.context, ctx.state.cardId);
      }
    }
  } else {
    showToast(languageResource.inputPinAndPuk);
  }
}
