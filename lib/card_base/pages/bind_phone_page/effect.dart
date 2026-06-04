
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
import '../../bean/country_register_info.dart';
import '../../bean/system_config.dart';
import 'action.dart';
import 'state.dart';

Effect<BindPhoneState>? buildEffect() {
  return combineEffects(<Object, Effect<BindPhoneState>>{
    Lifecycle.initState: _onInit,
    BindPhoneAction.bindClick: _onBindClick,
    BindPhoneAction.sendVerifiyCode: _onSendVerifyCode,
    BindPhoneAction.loadCountryList: _onLoadCountryList,
  });
}

Future<void> _onInit(Action action, Context<BindPhoneState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.systemConfigUrl);
  if(result.isSuccess){
    ctx.state.systemConfig = SystemConfig.fromJson(result.data);
  }else{
    ctx.dispatch(BindPhoneActionCreator.onLoadFailed(result.message));
    return;
  }
  ctx.dispatch(BindPhoneActionCreator.onLoadCountryList());
}

Future<void> _onLoadCountryList(Action action, Context<BindPhoneState> ctx) async {
  final result = await HttpManager.getInstance().get(NetworkAddress.countryUrl);
  if(result.isSuccess){
    List list = result.data;
    List<CountryRegisterInfo> countryList = list.map((e) => CountryRegisterInfo.fromJson(e)).toList();
    ctx.dispatch(BindPhoneActionCreator.onLoadSuccess(countryList));
  }else{
    ctx.dispatch(BindPhoneActionCreator.onLoadFailed(result.message));
  }
}

Future<void> _onBindClick(Action action, Context<BindPhoneState> ctx) async {
  KeyboardService.dismiss();
  FocusScope.of(ctx.context).requestFocus(FocusNode());

  String phoneNum = ctx.state.phoneController.text;
  String verifyCode = ctx.state.verifyController.text;

  if (phoneNum.isEmpty) {
    showToast(S.current.enterPhoneNo);
    return;
  }
  final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
  final mathPhone = RegExp(currentCountry.phoneRegx??'').hasMatch(phoneNum);
  if(!mathPhone){
    showToast('手机号格式错误');
    return;
  }

  if (verifyCode.isEmpty) {
    showToast(S.current.enterPhoneCode);
    return;
  }

  var password = ctx.state.passwordController.text;
  if ((ctx.state.systemConfig?.customerPasswordVerify ?? false) && password.isEmpty) {
    showToast(S.current.enterPwd);
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var params = {
    'isoCode': currentCountry.isoCode,
    "phone": phoneNum,
    'password': password,
    'code': verifyCode,
  };

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.bindPhoneUrl, null, data: params);
  pr.hide();
  if (resultData.isSuccess) {
    showDialog(context: ctx.context, builder: (context){
      return ZenggeTextAlertDialog(S.current.bindSuccess);
    }).then((value) async {
      var userInfo = LocalStorage.getCacheUserInfo()!;
      userInfo.customer?.phone = phoneNum;
      LocalStorage.saveUserInfo(userInfo);
      Navigator.of(ctx.context).pop(userInfo);
    });
  } else {
    showToast(resultData.message);
  }

}

Future<void> _onSendVerifyCode(
    Action action, Context<BindPhoneState> ctx) async {
  KeyboardService.dismiss();
  String phoneNum = ctx.state.phoneController.text;
  if (phoneNum.isEmpty) {
    showToast(S.current.enterPhoneNo);
    return;
  }
  final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
  final mathPhone = RegExp(currentCountry.phoneRegx??'').hasMatch(phoneNum);
  if(!mathPhone){
    showToast('手机号格式错误');
    return;
  }

  var params = {
    'isoCode': currentCountry.isoCode,
    'phone': phoneNum,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData =
      await HttpManager.getInstance().post(NetworkAddress.sendPhoneVerifyCodeUrl,null,data:params);
  await pr.hide();
  if (resultData.isSuccess) {
    showToast(S.current.sendCodeSuccess);
    ctx.state.sendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(resultData.message);
  }
}


