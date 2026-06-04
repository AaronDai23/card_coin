import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../http/address.dart';
import '../../../../../http/http_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<EditCardState>? buildEffect() {
  return combineEffects(<Object, Effect<EditCardState>>{
    EditCardAction.setMainClick: _onSetMainClick,
    EditCardAction.updateNameClick: _onUpdateNameClick,
  });
}

Future<void> _onSetMainClick(Action action, Context<EditCardState> ctx) async {
  Map<String, dynamic> params = {'id': ctx.state.cardInfo.id!};

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.setMainCardUrl, null, data: params);
  pr.hide();
  if (result.isSuccess) {
    ctx.broadcast(EditCardActionCreator.onUpdateCardInfo());
    Navigator.of(ctx.context).pop();
  } else {
    showToast(result.message);
  }
}

Future<void> _onUpdateNameClick(Action action, Context<EditCardState> ctx) async {
  String name = ctx.state.nameController.text;
  if(name.isEmpty){
    showToast(S.current.enterCardName);
    return;
  }
  Map<String, dynamic> params = {'id': ctx.state.cardInfo.id!,'name':name};

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.setCardNameUrl, null, data: params);
  pr.hide();
  if (result.isSuccess) {
    ctx.broadcast(EditCardActionCreator.onUpdateCardInfo());
    Navigator.of(ctx.context).pop();
  } else {
    showToast(result.message);
  }
}
