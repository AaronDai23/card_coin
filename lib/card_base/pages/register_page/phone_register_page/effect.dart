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
import '../../../../widget/custom_alert_dialog.dart';
import '../action.dart';
import 'action.dart';
import 'state.dart';

Effect<PhoneRegisterState>? buildEffect() {
  return combineEffects(<Object, Effect<PhoneRegisterState>>{
    Lifecycle.initState: _onInit,
    PhoneRegisterAction.sendVerifyCode: _onSendVerifyCode,
    PhoneRegisterAction.scanClick: _onScanClick,
    RegisterAction.registerAccount: _onRegisterAccount,
  });
}

Future<void> _onInit(Action action, Context<PhoneRegisterState> ctx) async {
  // ResultData result =
  // await HttpManager.getInstance().get(Address.registerCountryUrl, null);
  // if (result.isSuccess) {
  //   List list = result.data;
  //   List<CountryInfo> countryList = list.map((e) => CountryInfo.fromJson(e)).toList();
  // }
}

Future<void> _onSendVerifyCode(
    Action action, Context<PhoneRegisterState> ctx) async {
  KeyboardService.dismiss();
  var languageResource = ctx.state.languageResource!;
  String phoneNum = ctx.state.phoneController.text;
  if (phoneNum.isEmpty) {
    showToast(languageResource.enterPhoneNo,
        position: const ToastPosition(offset: 150));
    return;
  }

  final currentCountry = ctx.state.countryList[ctx.state.selectedIndex];
  final mathPhone = RegExp(currentCountry.phoneRegx ?? '').hasMatch(phoneNum);
  if (!mathPhone) {
    showToast(languageResource.phoneFormatError,
        position: const ToastPosition(offset: 150));
    return;
  }

  var inviteCode = ctx.state.inviteController.text;
  var params = {
    'isoCode': currentCountry.isoCode,
    'identifier': phoneNum,
    'identifierCarrier': 'MOBILE',
    "inviteCode": inviteCode,
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.registerVerifyUrl, null, data: params);
  await pr.hide();
  if (resultData.isSuccess) {
    showToast(languageResource.sendCodeSuccess,
        position: const ToastPosition(offset: 150));
    ctx.state.sendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(resultData.message, position: const ToastPosition(offset: 150));
  }
}

Future<void> _onScanClick(
    Action action, Context<PhoneRegisterState> ctx) async {
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
        showToast(resultData.message,
            position: const ToastPosition(offset: 150));
      }
      return;
    }
    showToast(languageResource.qrCodeError,
        position: const ToastPosition(offset: 150));
  }
}

Future<void> _onRegisterAccount(
    Action action, Context<PhoneRegisterState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var index = action.payload;
  if (index == ctx.state.tabIndex) {
    var phoneNum = ctx.state.phoneController.text;
    var verifyCode = ctx.state.verifyController.text;
    var inviteCode = ctx.state.inviteController.text;
    var password = ctx.state.passwordController.text;
    if (phoneNum.isEmpty) {
      showToast(languageResource.enterPhoneNo,
          position: const ToastPosition(offset: 150));
      return;
    }

    if (verifyCode.isEmpty) {
      showToast(languageResource.enterPhoneCode,
          position: const ToastPosition(offset: 150));
      return;
    }

    if (password.isEmpty) {
      showToast(languageResource.enterPwd,
          position: const ToastPosition(offset: 150));
      return;
    }
    String installUid = ctx.state.uid;
    String installTaskitemid = ctx.state.taskItemId;

    var params = {
      'code': verifyCode,
      'inviteCode': inviteCode,
      'isoCode': ctx.state.countryList[ctx.state.selectedIndex].isoCode,
      'identifier': phoneNum,
      'credential': password,
      "identifierCarrier": "MOBILE",
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
