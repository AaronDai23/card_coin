import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<AllActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<AllActivateState>>{
    Lifecycle.initState: _onInit,
    AllActivateAction.action: _onAction,
    AllActivateAction.activateClick: _onActivateClick,
  });
}

Future<void> _onInit(Action action, Context<AllActivateState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.activateSummaryUrl, queryParameters: {'uid': ctx.state.uid});
  if (result.isSuccess) {
    final activateSummary = ActivateSummary.fromJson(result.data);
    ctx.dispatch(AllActivateActionCreator.onLoadSuccess(activateSummary));
  } else {
    ctx.dispatch(AllActivateActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onActivateClick(Action action, Context<AllActivateState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var result = await showDialog(
      context: ctx.context,
      builder: (_) {
        return ZenggeTextAlertDialog(
          languageResource.activateAllTips,
          enableCancel: true,
          confirmText: languageResource.confirm,
          cancelText: languageResource.cancel,
        );
      });
  if (result == true) {
    final progressDialog = ProgressDialog(ctx.context);
    progressDialog.show();
    var response = await HttpManager.getInstance().post(NetworkAddress.activateCardV2Url,null, data: {'uid': ctx.state.uid, 'activationType': 'BATCH'});
    progressDialog.hide();
    if (response.isSuccess) {
      await showDialog(
          context: ctx.context,
          builder: (_) {
            return ZenggeTextAlertDialog(response.message, confirmText: languageResource.confirm);
          });
      Navigator.of(ctx.context).pop();
    } else {
      showToast(response.message);
    }
  }
}

void _onAction(Action action, Context<AllActivateState> ctx) {}
