import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../cache/bean/user_info_bean.dart';
import '../../../../cache/local_storage.dart';
import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../utils/string_util.dart';
import '../action.dart';
import 'action.dart';
import 'state.dart';

Effect<EmailRegisterState>? buildEffect() {
  return combineEffects(<Object, Effect<EmailRegisterState>>{
    EmailRegisterAction.sendVerifyCode: _onSendVerifyCode,
    EmailRegisterAction.scanClick: _onScanClick,
    RegisterAction.registerAccount: _onRegisterAccount
  });
}

Future<void> _onSendVerifyCode(
    Action action, Context<EmailRegisterState> ctx) async {
  KeyboardService.dismiss();
  var languageResource = ctx.state.languageResource!;
  String emailAddress = ctx.state.emailController.text;
  if (emailAddress.isEmpty) {
    showToast(languageResource.enterEmail,
        position: const ToastPosition(offset: 150));
    return;
  }

  if (!StringUtils.isEmail(emailAddress)) {
    showToast(languageResource.emailError,
        position: const ToastPosition(offset: 150));
    return;
  }

  var inviteCode = ctx.state.inviteController.text;

  var params = {
    'identifierCarrier': 'EMAIL',
    'identifier': emailAddress,
    "inviteCode": inviteCode,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.registerVerifyUrl, null, data: params);
  pr.hide();
  if (resultData.isSuccess) {
    showToast(languageResource.sendCodeSuccess);
    ctx.state.sendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(resultData.message);
  }
}

Future<void> _onScanClick(
    Action action, Context<EmailRegisterState> ctx) async {
  var status = await Permission.camera.request();
  var languageResource = ctx.state.languageResource!;
  if (status.isGranted) {
    final inviteCodeLink =
        await Navigator.of(ctx.context).pushNamed('scanQrcodePage');
    if (inviteCodeLink != null) {
      ProgressDialog pr = ProgressDialog(ctx.context);
      await pr.show();
      Map<String, dynamic> params = {'link': inviteCodeLink};
      var resultData = await HttpManager.getInstance()
          .post(NetworkAddress.getInviteCodeUrl, null, data: params);
      pr.hide();
      if (resultData.isSuccess) {
        String inviteCode = resultData.data['inviteCode'];
        ctx.state.inviteController.text = inviteCode;
      } else {
        showToast(resultData.message);
      }
      return;
    }
    showToast(languageResource.qrCodeError);
  }
}

Future<void> _onRegisterAccount(
    Action action, Context<EmailRegisterState> ctx) async {
  var index = action.payload;
  var languageResource = ctx.state.languageResource!;
  if (index == ctx.state.tabIndex) {
    var emailAddress = ctx.state.emailController.text;
    var verifyCode = ctx.state.verifyController.text;
    var inviteCode = ctx.state.inviteController.text;
    var password = ctx.state.passwordController.text;
    if (emailAddress.isEmpty) {
      showToast(languageResource.enterPhoneNo);
      return;
    }

    if (!StringUtils.isEmail(emailAddress)) {
      showToast(languageResource.emailError);
      return;
    }

    if (verifyCode.isEmpty) {
      showToast(languageResource.enterEmailCode);
      return;
    }

    if (password.isEmpty) {
      showToast(languageResource.enterPwd);
      return;
    }

    String installUid = ctx.state.uid;
    String installTaskitemid = ctx.state.taskItemId;

    var params = {
      'code': verifyCode,
      'inviteCode': inviteCode,
      'identifier': emailAddress,
      'credential': password,
      "identifierCarrier": "EMAIL",
      "identityType": "PASSWORD",
    };

    if (installUid.isNotEmpty) {
      params['uid'] = installUid;
    }
    if (installTaskitemid.isNotEmpty) {
      params['taskItemId'] = installTaskitemid;
    }

    ProgressDialog pr = ProgressDialog(ctx.context);
    await pr.show();

    var resultData = await HttpManager.getInstance()
        .post(NetworkAddress.registerBindUrl, null, data: params);
    pr.hide();
    if (resultData.isSuccess) {
      var userInfo = UserInfo.fromJson(resultData.data);
      LocalStorage.saveUserInfo(userInfo);
      Navigator.pushNamedAndRemoveUntil(
          ctx.context, 'cardBaseMainPage', (route) => false,
          arguments: {'userInfo': userInfo});
    } else {
      String content = '${resultData.message}\n';
      final data = resultData.data;
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
}
