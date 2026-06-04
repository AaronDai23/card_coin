import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<SelectedActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<SelectedActivateState>>{
    SelectedActivateAction.action: _onAction,
    SelectedActivateAction.activateClick: _onActivateClick,
  });
}

Future<void> _onActivateClick(Action action, Context<SelectedActivateState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var result = await showDialog(
      context: ctx.context,
      builder: (_) {
        return ZenggeTextAlertDialog(
          languageResource.activatePackageTips,
          enableCancel: true,
        );
      });
  if (result == true) {
    final progressDialog = ProgressDialog(ctx.context);
    progressDialog.show();
    final list = ctx.state.packageList.map((e) => e.packageNumber!).toList();
    var response = await HttpManager.getInstance()
        .post(NetworkAddress.activateCardV2Url, null, data: {'uid': ctx.state.uid, 'activationType': 'PACKAGE', 'packageNames': list});
    progressDialog.hide();
    if (response.isSuccess) {
      await showDialog(
          context: ctx.context,
          builder: (_) {
            return ZenggeTextAlertDialog(response.message, confirmText: languageResource.confirm);
          });
      ctx.broadcast(SelectedActivateActionCreator.onCardActivateChanged(list.length));
      Navigator.of(ctx.context).pop();
    } else {
      showToast(response.message);
    }
  }
}

void _onAction(Action action, Context<SelectedActivateState> ctx) {}
