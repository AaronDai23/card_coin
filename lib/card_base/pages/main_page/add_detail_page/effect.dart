import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:flutter/material.dart' hide Action;
import 'package:keyboard_service/keyboard_service.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../generated/l10n.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../http/result_data.dart';
import '../../../bean/link_bean.dart';
import 'action.dart';
import 'state.dart';

Effect<AddDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<AddDetailState>>{
    Lifecycle.initState: _onInit,
    AddDetailAction.buttonClick: _onButtonClick,
    AddDetailAction.loadData: _onInit,
    AddDetailAction.deleteLink: _onDeleteLink,
  });
}

Future<void> _onInit(Action action, Context<AddDetailState> ctx) async {
  Map<String, dynamic> params = {
    'cardId': ctx.state.cardId,
    'deviceId': ctx.state.deviceId
  };
  // String id = ctx.state.id == null?ctx.state.typeId!:ctx.state.id!;
  var linkResult = await HttpManager.getInstance().post(
      '${NetworkAddress.socialLinksUrl}/${ctx.state.type}', null,
      data: params);
  if (linkResult.isSuccess) {
    var linkTypeDetail = LinkTypeDetail.fromJson(linkResult.data);
    ctx.dispatch(AddDetailActionCreator.onLoadSuccess(linkTypeDetail));
  } else {
    ctx.dispatch(AddDetailActionCreator.onLoadFailure(linkResult.message));
  }
}

Future<void> _onDeleteLink(Action action, Context<AddDetailState> ctx) async {
  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var params = {
    'id': ctx.state.id!,
    'name': ctx.state.name,
    'label': '',
    'type': ctx.state.type,
    'value': ctx.state.value,
    'description': ctx.state.description,
    'imageUrl': ctx.state.imageUrl
  };

  ResultData result = await HttpManager.getInstance()
      .post(NetworkAddress.deleteSocicalLinkUrl, null, data: [params]);
  pr.hide();
  if (result.isSuccess) {
    showToast(S.current.deleteSuccess);
    ctx.dispatch(AddDetailActionCreator.onLoadData());
    Navigator.of(ctx.context).pop();
  } else {
    showToast(result.message);
  }
}

Future<void> _onButtonClick(Action action, Context<AddDetailState> ctx) async {
  KeyboardService.dismiss();
  FocusScope.of(ctx.context).requestFocus(FocusNode());
  var valueText = ctx.state.valueController.text;
  if (valueText.isEmpty) {
    showToast(S.current.enterAccountInfo);
    return;
  }

  String regx = ctx.state.typeDetail?.regx ?? '';
  if (!(regx != '' && RegExp(regx).hasMatch(valueText))) {
    showToast(S.current.enterFormatError);
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();

  bool isEdit = ctx.state.id != null;
  String requestUrl;
  var params = {
    'label': '',
    'type': ctx.state.type,
    'value': valueText,
    'description': ctx.state.description,
    'imageUrl': ctx.state.imageUrl,
  };
  if (isEdit) {
    params['id'] = ctx.state.id!;
    requestUrl = NetworkAddress.updateSocicalLinkUrl;
  } else {
    params['id'] = ctx.state.typeId!;
    requestUrl = NetworkAddress.createSocialUrl;
  }

  ResultData result =
      await HttpManager.getInstance().post(requestUrl, null, data: {
    'cardId': ctx.state.cardId,
    'deviceId': ctx.state.deviceId,
    'buttons': [params]
  });

  pr.hide();
  if (result.isSuccess) {
    showToast(isEdit ? S.current.modifySuccess : S.current.addSuccess);
    ctx.dispatch(AddDetailActionCreator.onUpdateLink());
    Navigator.of(ctx.context).pop(ctx.state.typeId);
  } else {
    print('error :${result.message}');
    showToast(result.message);
  }
}
