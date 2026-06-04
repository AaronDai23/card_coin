
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../http/result_data.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<UpdatePasswordState>? buildEffect() {
  return combineEffects(<Object, Effect<UpdatePasswordState>>{
    UpdatePasswordAction.updateClick: _onUpdateClick,
  });
}

Future<void> _onUpdateClick(Action action, Context<UpdatePasswordState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var oldPassword = ctx.state.oldPwdController.text;
  if(oldPassword.isEmpty){
    showToast(languageResource.enterOriginPwd);
    return;
  }

  var password  = ctx.state.pwdController.text;
  if(password.isEmpty){
    showToast(languageResource.enterNewPwd);
    return;
  }

  var confirmPassword = ctx.state.confirmPwdController.text;
  if(confirmPassword != password){
    showToast(languageResource.twicePwd);
    return;
  }


  var params = {
    'oldPassword': oldPassword,
    'newPassword': password,
    'repeatPassword': confirmPassword,
  };


  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.showNoMask();

  ResultData result = await HttpManager.getInstance().post(NetworkAddress.updatePwdUrl,null,data:params);

  pr.hide();
  if(result.isSuccess){
    await showDialog(context: ctx.context, builder: (context){
      return ZenggeTextAlertDialog(languageResource.modifyPwdSuccess);
    });
  Navigator.of(ctx.context).pop();
  }else{
    String content = '${result.message}\n';
    final data = result.data;
    if(data is List){
      content += data.map((e) => e.toString()).join('\n');
    }
    showDialog(context: ctx.context, builder: (context){
      return ZenggeTextAlertDialog(content,titleText: languageResource.operateError,);
    });
  }
}
