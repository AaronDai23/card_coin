import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'package:oktoast/oktoast.dart';

import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../http/result_data.dart';
import '../../../utils/string_util.dart';
import '../../../widget/custom_alert_dialog.dart';
import '../../bean/country_register_info.dart';
import 'action.dart';
import 'state.dart';

Effect<ForgotPasswordState>? buildEffect() {
  return combineEffects(<Object, Effect<ForgotPasswordState>>{
    Lifecycle.initState: _onInit,
    ForgotPasswordAction.sendClick: _onSendClick,
    ForgotPasswordAction.resetClick: _onResetClick,
    ForgotPasswordAction.loadCountryList: _onLoadCountryList,
  });
}

Future<void> _onInit(Action action, Context<ForgotPasswordState> ctx) async {
  ctx.dispatch(ForgotPasswordActionCreator.onLoadCountryList());
}

Future<void> _onSendClick(
    Action action, Context<ForgotPasswordState> ctx) async {
  FocusScope.of(ctx.context).unfocus();

  final languageResource = ctx.state.languageResource!;
  Map<String, dynamic> params;
  if (ctx.state.isPhone) {

    var phone = ctx.state.phoneController.text;
    if (phone.isEmpty) {
      showToast(languageResource.enterPhoneNo);
      return;
    }
    final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
    final mathPhone = RegExp(currentCountry.phoneRegx??'').hasMatch(phone);
    if(!mathPhone){
      showToast('手机号格式错误');
      return;
    }

    params = {
      'identifierCarrier': 'MOBILE',
      'identifier': phone,
      'isoCode': currentCountry.isoCode,
    };
  } else {

    var email = ctx.state.emailController.text;
    if (email.isEmpty) {
      showToast(languageResource.enterEmail);
      return;
    }

    if (!StringUtils.isEmail(email)){
      showToast(languageResource.emailError);
      return;
    }

    params = {
      'identifierCarrier': 'EMAIL',
      'identifier': email,
    };
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.showNoMask();

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.forgotVerifyUrl, null, data: params);

  pr.hide();
  if (result.isSuccess) {
    showToast(languageResource.sendCodeSuccess);
    ctx.state.verificationController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(result.message);
  }
}

Future<void> _onLoadCountryList(
    Action action, Context<ForgotPasswordState> ctx) async {
  final result = await HttpManager.getInstance().get(NetworkAddress.countryUrl);
  if (result.isSuccess) {
    List list = result.data;
    List<CountryRegisterInfo> countryList =
        list.map((e) => CountryRegisterInfo.fromJson(e)).toList();
    ctx.dispatch(ForgotPasswordActionCreator.onLoadSuccess(countryList));
  } else {
    ctx.dispatch(ForgotPasswordActionCreator.onLoadFailed(result.message));
  }
}

Future<void> _onResetClick(
    Action action, Context<ForgotPasswordState> ctx) async {
  FocusScope.of(ctx.context).unfocus();
  final languageResource = ctx.state.languageResource!;

  Map<String,dynamic> params;

  var code = ctx.state.codeController.text;
  if (code.isEmpty) {
    showToast(languageResource.enterPhoneCode);
    return;
  }

  var password = ctx.state.pwdController.text;
  if (password.isEmpty) {
    showToast(languageResource.enterNewPwd);
    return;
  }

  var confirmPassword = ctx.state.confirmPwdController.text;
  if (confirmPassword != password) {
    showToast(languageResource.twicePwd);
    return;
  }

  if(ctx.state.isPhone){
    var phone = ctx.state.phoneController.text;
    if (phone.isEmpty) {
      showToast(languageResource.enterPhoneNo);
      return;
    }
    final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
    final mathPhone =
    RegExp(currentCountry.phoneRegx ?? '').hasMatch(phone);
    if (!mathPhone) {
      showToast(languageResource.phoneFormatError);
      return;
    }
    params = {
      'identifierCarrier': 'MOBILE',
      'identifier': phone,
      'isoCode': currentCountry.isoCode,
      'newPassword': password,
      'repeatPassword': confirmPassword,
      'code': code,
    };
  }else{

    var email = ctx.state.emailController.text;
    if (email.isEmpty) {
      showToast(languageResource.enterEmail);
      return;
    }

    params = {
      'identifierCarrier': 'EMAIL',
      'identifier': email,
      'newPassword': password,
      'repeatPassword': confirmPassword,
      'code': code,
    };
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.showNoMask();

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.resetPwdUrl, null, data: params);

  pr.hide();
  if (result.isSuccess) {
    await showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(languageResource.resetPwdSuccess);
        });
    Navigator.of(ctx.context).pop();
  } else {
    String content = '${result.message}\n';
    final data = result.data;
    if (data is List) {
      content += data.map((e) => e.toString()).join('\n');
    }
    showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(
            content,
            titleText: languageResource.operateError,
          );
        });
  }
}
