import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/dialogs.dart';
import 'package:card_coin/utils/runnable/import_card_data_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<CreateBackupState>? buildEffect() {
  return combineEffects(<Object, Effect<CreateBackupState>>{
    CreateBackupAction.action: _onAction,
    CreateBackupAction.onAddBackUpCard: _onAddBackUpCard,
  });
}

void _onAction(Action action, Context<CreateBackupState> ctx) {}

Future<void> _onAddBackUpCard(
    Action action, Context<CreateBackupState> ctx) async {
  List<int>? pinCode = await _onShowPinCodeDialog(ctx);

  if (pinCode == null) return;
  var languageResource = ctx.state.languageResource!;
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  ScanResponse scanResponse = await ScanUtil.chipScanWithRunnable(
      ImportCardDataRunnable(
        pinCode: pinCode,
        cardData: ctx.state.cardData,
      ),
      expectedCardId: ctx.state.cardId,
      cardNo: cardNo);
  if (!scanResponse.isSuccess) {
    int? sw1 = scanResponse.sw1;
    int? sw2 = scanResponse.sw2;
    print('sw1: $sw1, sw2: $sw2');
    String? error;
    if (sw1 == 0xAA && sw2 == 0x31) {
      // error = 'ECC Key Pair exist';
      error = languageResource.cardResetTips;
    }
    showToast(error ?? scanResponse.message ?? '');
    return;
  }

  await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(languageResource.backUpSuccess);
      });
  Navigator.pushNamedAndRemoveUntil(
      ctx.context, 'cardBaseMainPage', (route) => false);
  // Navigator.of(ctx.context).popUntil(ModalRoute.withName('hdWalletListPage'));
}

Future<List<int>?> _onShowPinCodeDialog(Context<CreateBackupState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  List<int>? pinCode = [];
  pinCode = await Dialogs.showPinInputDialog(
      languageResource: languageResource,
      context: ctx.context,
      title: languageResource.inputPinCode);
  return pinCode;
}
