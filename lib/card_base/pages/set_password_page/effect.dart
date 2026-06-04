
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../cache/local_storage.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../widget/custom_alert_dialog.dart';
import '../../bean/setting_bean.dart';
import '../../widgets/custom_bottom_dialog.dart';
import '../../widgets/show_zengge_bottom_sheet.dart';
import 'action.dart';
import 'state.dart';

Effect<SetPasswordState>? buildEffect() {
  return combineEffects(<Object, Effect<SetPasswordState>>{
    Lifecycle.initState: _onInit,
    SetPasswordAction.loadData: _onloadData,
    SetPasswordAction.sendVerifiyCode: _onSendVerifyCode,
    SetPasswordAction.confirmClick: _onConfirmClick,
    SetPasswordAction.changeMethod: _onChangedMethod,
  });
}

Future<void> _onChangedMethod(Action action, Context<SetPasswordState> ctx) async {
  var result = await showListSelectBottomSheet(
      context: ctx.context,
      title: S.current.changeVerify,
      list: ctx.state.verifyMethods
          .map((e) => ListSelectBottomSheetItem(e.method!))
          .toList());

  if(result != null){
    ctx.dispatch(SetPasswordActionCreator.onUpdateMethodIndex(result));
  }
}

void _onInit(Action action, Context<SetPasswordState> ctx) {
  ctx.dispatch(SetPasswordActionCreator.onLoadData());
}

Future<void> _onSendVerifyCode(
    Action action, Context<SetPasswordState> ctx) async {
  KeyboardService.dismiss();

  var params = {
    'method': ctx.state.verifyMethods[ctx.state.index].method,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.setPasswordVerifyUrl, null, data: params);
  await pr.hide();
  if (resultData.isSuccess) {
    showToast(S.current.sendCodeSuccess);
    ctx.state.sendController.startCountdown();
  } else {
    showToast(resultData.message);
  }
}

Future<void> _onloadData(Action action, Context<SetPasswordState> ctx) async {
  Map<String, dynamic> params = {};
  var result =
      await HttpManager.getInstance().get(NetworkAddress.verifyMethodUrl, queryParameters: params);
  if (result.isSuccess) {
    List<dynamic> datas = result.data;
    List<VerifyMethod> verifyMethods =
        datas.map((e) => VerifyMethod.fromJson(e)).toList();
    ctx.dispatch(SetPasswordActionCreator.onLoadSuccess(verifyMethods));
  } else {
    ctx.dispatch(SetPasswordActionCreator.onLoadFailure(result.message));
    return;
  }
}

Future<void> _onConfirmClick(
    Action action, Context<SetPasswordState> ctx) async {
  var verifyCode = ctx.state.verifyController.text;
  var password = ctx.state.passwordController.text;
  if (verifyCode.isEmpty) {
    showToast(S.current.enterPhoneCode);
    return;
  }

  if (password.isEmpty) {
    showToast(S.current.enterPwd);
    return;
  }

  KeyboardService.dismiss();

  Map<String, dynamic> params = {
    'code': verifyCode,
    'password': password,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.setPasswordUrl, null, data: params);
  await pr.hide();
  if (result.isSuccess) {

    var userInfo = LocalStorage.getCacheUserInfo();
    userInfo?.customer?.needSetPassword = false;
    LocalStorage.saveUserInfo(userInfo!);
    showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(
            S.current.setPwdSuccess,
            confirmText: S.current.comfirm,
          );
        }).then((value) => Navigator.of(ctx.context).pop(userInfo));

  } else {
    String content = '${result.message}\n';
    final data = result.data;
    if(data is List){
      content += data.map((e) => e.toString()).join('\n');
    }
    showDialog(context: ctx.context, builder: (context){
      return ZenggeTextAlertDialog(content,titleText: S.current.operateError,);
    });
    showToast(result.message);
  }
}
