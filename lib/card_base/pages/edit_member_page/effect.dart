import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<EditMemberState>? buildEffect() {
  return combineEffects(<Object, Effect<EditMemberState>>{
    Lifecycle.initState: _onInit,
    EditMemberAction.submitClick: _onSubmitClick,
    EditMemberAction.loadData: _onInit,
  });
}

Future<void> _onInit(Action action, Context<EditMemberState> ctx) async {
  Map<String, dynamic> params = {'deviceId': ctx.state.cardId};
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.bindCardVerify, null, data: params);
  if (result.isSuccess) {
    bool isBind = result.data['result'];
    ctx.dispatch(EditMemberActionCreator.onLoadSuccess(isBind));
    if(isBind){
      await showDialog(
          context: ctx.context,
          barrierDismissible: false,
          builder: (context) {
            return ZenggeTextAlertDialog(ctx.state.languageResource!.alreadyBind);
          });

      Navigator.of(ctx.context).pop();
    }

  } else {
    ctx.dispatch(EditMemberActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onSubmitClick(Action action, Context<EditMemberState> ctx) async {
  String name = ctx.state.phoneController.text;
  if (name.isEmpty) {
    showToast(S.current.enterMemberPhone);
    return;
  }

  String remark = ctx.state.remarkController.text;

  Map<String, dynamic> params = {
    'amount': ctx.state.cardInfo.amount,
    'brand': ctx.state.cardInfo.brand,
    'cardNo': ctx.state.cardInfo.cardNum,
    'nickName': remark,
    'category': ctx.state.cardInfo.brand == 'Other'?'OTHER_NFC':'HIGHWAY',
    'phone': name,
    'deviceId': ctx.state.cardId,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.createMemberUrl, null, data: params);
  pr.hide();
  if (result.isSuccess) {
    ctx.broadcast(EditMemberActionCreator.onUpdateCardInfo());
    Navigator.of(ctx.context).pop(true);
  } else {
    showToast(result.message);
  }
}
