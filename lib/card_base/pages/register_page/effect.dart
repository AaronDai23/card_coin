import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:card_coin/card_base/bean/login_bean.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import 'package:collection/collection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../widgets/show_zengge_bottom_sheet.dart';
import 'action.dart';
import 'state.dart';

Effect<RegisterState>? buildEffect() {
  return combineEffects(<Object, Effect<RegisterState>>{
    Lifecycle.initState: _onInit,
    RegisterAction.sendVerificationCode: _onSendVerifiyCode,
    RegisterAction.registerClick: _onRegisterClick,
    RegisterAction.scanClick: _onScanClick,
    RegisterAction.showRegisterList: _onShowRegisterList,
  });
}

Future<void> _onInit(Action action, Context<RegisterState> ctx) async {
  print('register page init effect');
  var result = await HttpManager.getInstance().get(NetworkAddress.countryUrl);
  if (result.isSuccess) {
    List list = result.data;
    List<CountryRegisterInfo> countryList =
        list.map((e) => CountryRegisterInfo.fromJson(e)).toList();
    ctx.state.countryList = countryList;
  } else {
    ctx.dispatch(RegisterActionCreator.onLoadFailed(result.message));
    return;
  }

  result =
      await HttpManager.getInstance().get(NetworkAddress.registerMethodUrl);

  if (result.isSuccess) {
    List<dynamic> list = result.data;
    List<LoginMethod> registerMethodList =
        list.map((e) => LoginMethod.fromJson(e)).toList();
    registerMethodList.retainWhere((element) => element.status == 'ACTIVE');
    registerMethodList.sort((a, b) => a.seq!.compareTo(b.seq!));
    ctx.dispatch(RegisterActionCreator.onLoadSuccess(registerMethodList));
  } else {
    ctx.dispatch(RegisterActionCreator.onLoadFailed(result.message));
  }
}

Future<void> _onRegisterClick(Action action, Context<RegisterState> ctx) async {
  KeyboardService.dismiss();
  if (!ctx.state.isAgree) {
    showToast(ctx.state.languageResource!.agreementTip,
        position: const ToastPosition(offset: 150));
    return;
  }

  ctx.broadcast(
      RegisterActionCreator.onRegisterAccount(ctx.state.currentIndex));
}

Future<void> _onSendVerifiyCode(
    Action action, Context<RegisterState> ctx) async {
  KeyboardService.dismiss();
  var languageResource = ctx.state.languageResource!;
  showToast(languageResource.sendCodeSuccess,
      position: const ToastPosition(offset: 150));
  String phoneNum = ctx.state.phoneController.text;
  if (phoneNum.isEmpty) {
    showToast(languageResource.enterPhoneNo,
        position: const ToastPosition(offset: 150));
    return;
  }

  var params = {
    'isoCode': '86',
    'identifier': phoneNum,
    'identifierCarrier': 'MOBILE'
  };

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.registerVerifyUrl, null, data: params);
  pr.hide();
  if (resultData.isSuccess) {
    showToast(languageResource.sendCodeSuccess,
        position: const ToastPosition(offset: 150));
    ctx.state.sendController.startCountdown();
    FocusScope.of(ctx.context).requestFocus(ctx.state.verifyFocusNode);
  } else {
    showToast(resultData.message, position: const ToastPosition(offset: 150));
  }
}

Future<void> _onShowRegisterList(
    Action action, Context<RegisterState> ctx) async {
  var index = await showMenuSelectBottomSheet(
      context: ctx.context,
      isCheck: ctx.state.currentIndex,
      list: ctx.state.registerMethodList.mapIndexed((index, e) {
        var item = ctx.state.registerMethodList[index];
        return Container(
          height: 40.0,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            item.name ?? '',
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList());

  if (index != null) {
    ctx.dispatch(RegisterActionCreator.onChangeType(index));
  }
}

Future<void> _onScanClick(Action action, Context<RegisterState> ctx) async {
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
