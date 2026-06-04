import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/widgets/count_down_button.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/utils/runnable/create_pin_runnable.dart';
import 'package:card_coin/utils/runnable/update_pin_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/utils/string_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';

import 'action.dart';
import 'state.dart';

Effect<SetPinCodeState>? buildEffect() {
  return combineEffects(<Object, Effect<SetPinCodeState>>{
    SetPinCodeAction.setPinCodeClick: _onSetPinCodeClick,
    SetPinCodeAction.cancelPinCode: _onCancelPinCode,
  });
}

Future<void> _onCancelPinCode(
    Action action, Context<SetPinCodeState> ctx) async {
  var result = await Navigator.of(ctx.context)
      .pushNamed('cancelPinCodePage', arguments: {'cardId': ctx.state.cardId});
  if (result == true) {
    Navigator.of(ctx.context).pop();
  }
}

Future<void> _onSetPinCodeClick(
    Action action, Context<SetPinCodeState> ctx) async {
  var languageResource = ctx.state.languageResource!;

  String pinCodeStr = ctx.state.pinCodeController.text;
  if (pinCodeStr.isNotEmpty) {
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

    ScanResponse response;
    if (ctx.state.pinCodeInfo.isOpen) {
      List<int> newPinCode = [];
      String newPinCodeStr = ctx.state.newPinCodeController.text;
      for (int j = 0; j < newPinCodeStr.length; j++) {
        newPinCode.add(int.parse(newPinCodeStr[j]));
      }
      String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);

      response = await ScanUtil.chipScanWithRunnable(
          UpdatePinRunnable(pinCode: pinCode, newPinCode: newPinCode),
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
              return const ZenggeTextAlertDialog("Update PIN Success");
            });
        Navigator.of(ctx.context).pop(true);
      } else {
        if (response.message != null &&
            response.message!.isNotEmpty &&
            response.message!.length < 100) {
          await ScanUtil.unlockTip(response, ctx.context, ctx.state.cardId);
        }
      }
    } else {
      String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
      response = await ScanUtil.chipScanWithRunnable(CreatePinRunnable(pinCode),
          expectedCardId: ctx.state.cardId, cardNo: cardNo);
      if (response.isSuccess) {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 200);
        }
        final pukCode = response.data!.toString().substring(0, 8);
        LogUtil.d('result.data.puk:$pukCode');
        Future.delayed(const Duration(milliseconds: 500), () async {
          await showDialog(
              context: ctx.context,
              barrierDismissible: false,
              builder: (context) {
                return SimpleDialog(
                  title: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4))),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/warning.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Important Note',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  children: [
                    Text(languageResource.getPukCodeTips2),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Please Remenber PUK:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300)),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          pukCode,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              letterSpacing: 10),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CCButton(
                            child: Text(languageResource.copyPuk),
                            onPressed: () {
                              try {
                                Clipboard.setData(ClipboardData(text: pukCode))
                                    .then((value) {
                                  showToast(languageResource.copySuccess);
                                });
                              } catch (error) {
                                showToast(languageResource
                                    .getOperateErrorWithInfo(error.toString()));
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CountDownButton(
                            text: languageResource.confirm,
                            backgroundColor: Colors.black,
                            count: 10,
                            onPressed: () => Navigator.of(ctx.context).pop(),
                          ),
                        )
                      ],
                    )
                  ],
                );
              });
          Navigator.of(ctx.context).pop(true);
        });
      } else {
        if (response.message != null &&
            response.message!.isNotEmpty &&
            response.message!.length < 50) {
          await ScanUtil.unlockTip(response, ctx.context, ctx.state.cardId);
        }
      }
    }
  }
}
