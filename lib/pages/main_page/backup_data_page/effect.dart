import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/utils/dialogs.dart';
import 'package:card_coin/utils/runnable/export_card_data_runnable.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../utils/runnable/bean/pin_code_info.dart';
import '../../../utils/runnable/query_pin_status_runnable.dart';
import 'action.dart';
import 'state.dart';

Effect<BackupDataState>? buildEffect() {
  return combineEffects(<Object, Effect<BackupDataState>>{
    BackupDataAction.action: _onAction,
    BackupDataAction.onScanCard: _onScanCard,
  });
}

void _onAction(Action action, Context<BackupDataState> ctx) {}

Future<void> _onScanCard(Action action, Context<BackupDataState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  String? cardNo = await LocalStorage.getCardNo(ctx.state.cardId);
  var queryPinResponse = await ScanUtil.chipScanWithRunnable(
      QueryPinStatusRunnable(),
      expectedCardId: ctx.state.cardId,
      cardNo: cardNo);
  if (queryPinResponse.isSuccess) {
    print("dddddddd,pinCodeInfo1:${queryPinResponse.data}");
    var pinCodeInfo = queryPinResponse.data;
    print("dddddddd,pinCodeInfo0:$pinCodeInfo");
    if ((pinCodeInfo is int && pinCodeInfo != 1) ||
        pinCodeInfo is PinCodeInfo && !pinCodeInfo.isOpen) {
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(languageResource.notSetPinCode);
          });
      return;
    }
    print("dddddddd,pinCodeInfo3:$pinCodeInfo");
  } else {
    showToast(queryPinResponse.message ?? '');
    return;
  }

  List<int>? pinCode = await _onShowPinCodeDialog(ctx);

  if (pinCode == null) return;
  ScanResponse scanResponse = await ScanUtil.chipScanWithRunnable(
      ExportCardDataRunnable(pinCode: pinCode),
      expectedCardId: ctx.state.cardId,
      cardNo: cardNo);
  if (!scanResponse.isSuccess) {
    print("dddddddd,pinCodeInfo-data:${scanResponse.data}");
    int? sw1 = scanResponse.sw1;
    int? sw2 = scanResponse.sw2;
    String? error;
    if (sw1 == 0xAA && sw2 == 0x22) {
      // error = 'ECC Key Pair exist';
      error = languageResource.cardPinCodeTips;
    } else if (sw1 == 0xAA && sw2 == 0x30) {
      error = languageResource.cardAddTips;
    }
    showToast(error ?? scanResponse.message ?? '');
    return;
  }

  Navigator.of(ctx.context).pushNamed('createBackupPage', arguments: {
    'cardData': scanResponse.data,
    'cardId': ctx.state.cardId,
    'cardDetail': ctx.state.cardDetail
  });
}

Future<List<int>?> _onShowPinCodeDialog(Context<BackupDataState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  List<int>? pinCode = [];
  pinCode = await Dialogs.showPinInputDialog(
      languageResource: languageResource,
      context: ctx.context,
      title: languageResource.inputPinCode);
  return pinCode;
}
