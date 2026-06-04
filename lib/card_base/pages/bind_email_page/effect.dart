
import 'package:card_coin/card_base/bean/system_config.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../cache/local_storage.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../utils/string_util.dart';
import '../../../widget/custom_alert_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<BindEmailState>? buildEffect() {
  return combineEffects(<Object, Effect<BindEmailState>>{
    Lifecycle.initState: _onInit,
    BindEmailAction.sendEmailVerifiyCode: _onSendEmailVerifiyCode,
    BindEmailAction.emailBindClick: _onEmailBindClick,
  });
}

Future<void> _onInit(Action action, Context<BindEmailState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.systemConfigUrl);
  if(result.isSuccess){
    SystemConfig systemConfig = SystemConfig.fromJson(result.data);
    ctx.dispatch(BindEmailActionCreator.onLoadSuccess(systemConfig));
  }else{
    ctx.dispatch(BindEmailActionCreator.onLoadFailed(result.message));
  }


}


Future<void> _onEmailBindClick(Action action, Context<BindEmailState> ctx) async {
  KeyboardService.dismiss();
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  String verifyCode = ctx.state.emailVerifyController.text;
  String password = ctx.state.pwdController.text;
  if(emailAddress.isEmpty){
    showToast(languageResource.enterEmail);
    return;
  }
  if(verifyCode.isEmpty){
    showToast(languageResource.enterEmailCode);
    return;
  }
  if((ctx.state.systemConfig?.customerPasswordVerify??false) && password.isEmpty){
    showToast(languageResource.enterPwd);
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var params = {
    "code": verifyCode,
    "email": emailAddress,
    "password": password,
  };

  var resultData = await HttpManager.getInstance().post(NetworkAddress.bindEmailUrl, null,data: params);
  pr.hide();

  if(resultData.isSuccess){
    showDialog(context: ctx.context, builder: (context){
      return ZenggeTextAlertDialog(languageResource.bindSuccess);
    }).then((value) async {
      var userInfo = LocalStorage.getCacheUserInfo()!;
      userInfo.customer?.email = emailAddress;
      LocalStorage.saveUserInfo(userInfo);
      Navigator.of(ctx.context).pop(userInfo);
    });
  }else{
    print('绑定失败 ：${resultData.message}');
    showToast(resultData.message);
  }
}

Future<void> _onSendEmailVerifiyCode(Action action, Context<BindEmailState> ctx) async {
  KeyboardService.dismiss();
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  if(emailAddress.isEmpty){
    showToast(languageResource.enterEmail);
    return;
  }

  if (!StringUtils.isEmail(emailAddress)){
    showToast(languageResource.emailError);
    return;
  }

  var params = {
    'email':emailAddress,
  };

  ProgressDialog pr =  ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance().post(NetworkAddress.emailVerifyUrl,null, data:params);
  await pr.hide();
  if(resultData.isSuccess){
    showToast(languageResource.sendCodeSuccess);
    ctx.state.emailSendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  }else{
    showToast(resultData.message);
  }
}