import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../http/address.dart';
import '../../../../../http/http_manager.dart';
import '../../../../../widget/custom_alert_dialog.dart';
import '../edit_card_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<AddCardState>? buildEffect() {
  return combineEffects(<Object, Effect<AddCardState>>{
    Lifecycle.initState: _onInit,
    AddCardAction.submitClick: _onSubmitClick,
    AddCardAction.loadData: _onInit
  });
}

Future<void> _onInit(Action action, Context<AddCardState> ctx) async {
  Map<String, dynamic> params = {'deviceId': ctx.state.cardId};
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.bindCardVerify, null, data: params);
  if (result.isSuccess) {
    bool isBind = result.data['result'];
    ctx.dispatch(AddCardActionCreator.onLoadSuccess(isBind));
    if (isBind) {
      await showDialog(
          context: ctx.context,
          barrierDismissible: false,
          builder: (context) {
            return ZenggeTextAlertDialog(S.current.alreadyBind);
          });

      Navigator.of(ctx.context).pop();

    }

  } else {
    ctx.dispatch(AddCardActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onSubmitClick(Action action, Context<AddCardState> ctx) async {
  KeyboardService.dismiss();
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  String name = ctx.state.nameController.text;
  if (name.isEmpty) {
    showToast(S.current.enterCardName);
    return;
  }

  String password = ctx.state.passwordController.text;
  if (password.isEmpty) {
    showToast(S.current.enterPwd);
    return;
  }

  print('isMajor2222:${ctx.state.isMajor}');
  Map<String, dynamic> params = {
    'amount': ctx.state.cardInfo.amount.toString(),
    'brand': ctx.state.cardInfo.brand,
    'cardNo': ctx.state.cardInfo.cardNum,
    'category': ctx.state.cardInfo.brand == 'Other'?'OTHER_NFC':'HIGHWAY',
    'name': name,
    'nfcDevice': ctx.state.cardId,
    'password': password,
    'major': ctx.state.isMajor
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.bindNfcUrl, null, data: params);
  pr.hide();
  if (result.isSuccess) {
    if (!ctx.state.isMajor) {
      ctx.broadcast(EditCardActionCreator.onUpdateCardInfo());
    }
    Navigator.of(ctx.context).pop(true);
  } else {
    showToast(result.message);
  }
}

// Future<void> _onSetMainClick(Context<AddCardState> ctx,String id) async {
//   Map<String, dynamic> params = {'id': ctx.state.cardInfo.id!};
//
//   ProgressDialog pr = ProgressDialog(ctx.context);
//   await pr.show();
//   var result = await HttpManager.getInstance()
//       .post(Address.setMainCardUrl, null, data: params);
//   pr.hide();
//   if (result.isSuccess) {
//     ctx.broadcast(EditCardActionCreator.onUpdateCardInfo());
//     Navigator.of(ctx.context).pop();
//   } else {
//     showToast(result.message);
//   }
// }
