import 'dart:io';
import 'dart:typed_data';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';

import '../../../utils/runnable/cancel_pin_runnable.dart';
import '../../../utils/scan_util.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<CancelPinCodeState>? buildEffect() {
  return combineEffects(<Object, Effect<CancelPinCodeState>>{
    CancelPinCodeAction.confirmClick: _onConfirmClick,
  });
}

Future<void> _onConfirmClick(
    Action action, Context<CancelPinCodeState> ctx) async {
  String pinCodeStr = ctx.state.pinCodeController.text;
  String pukCodeStr = ctx.state.pukCodeController.text;
  var languageResource = ctx.state.languageResource!;
  if (pinCodeStr.isNotEmpty && pukCodeStr.isNotEmpty) {
    if (pinCodeStr.length != 6) {
      showToast(languageResource.pinCodeDigitsTips);
      return;
    }

    if (!StringUtils.isNumeric(pinCodeStr)) {
      showToast(languageResource.pinCodeNumTips);
      return;
    }
    List<int> pinCode = [];
    for (int i = 0; i < pinCodeStr.length; i++) {
      pinCode.add(int.parse(pinCodeStr[i]));
    }

    if (pukCodeStr.length != 8) {
      showToast(languageResource.pukCodeDigitsTips);
      return;
    }

    Uint8List pukCode;
    try {
      List<int> pukIntList = [];
      for (int i = 0; i < pukCodeStr.length; i++) {
        pukIntList.add(int.parse(pukCodeStr[i]));
      }
      pukCode = Uint8List.fromList(pukIntList);
    } catch (error) {
      showToast(languageResource.pukCodeError);
      return;
    }
    String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
    ScanResponse response = await ScanUtil.chipScanWithRunnable(
        CancelPinRunnable(pinCode: pinCode, pukCode: pukCode),
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
            return const ZenggeTextAlertDialog("PIN Removed");
          });

      Navigator.of(ctx.context).pop(true);
    } else {
      // if (response.message != "Session invalidated by user") {

      if (response.message != null && response.message!.length <= 100) {
        if (Platform.isIOS) {
          var result = await showDialog(
              context: ctx.context,
              builder: (_) {
                return ZenggeTextAlertDialog(
                  response.message!,
                  enableCancel: false,
                  confirmText: "Confirm",
                );
              });

          if (result == true &&
              (response.message!.contains("Card is locked") ||
                  response.message!.contains("DeviceLockError"))) {
            Navigator.of(ctx.context).pop(true);
            print("ios pop :${response.message!}");
          }
        } else if (response.message!.contains("Card is locked") ||
            response.message!.contains("DeviceLockError")) {
          // 安卓 被锁
          showToast("Card is locked");
          if (response.message!.contains("Card is locked") ||
              response.message!.contains("DeviceLockError")) {
            Navigator.of(ctx.context).pop(true);
          }
        }
      }

      // }
    }
  }
}
