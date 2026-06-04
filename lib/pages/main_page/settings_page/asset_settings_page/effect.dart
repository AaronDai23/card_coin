
import 'package:card_coin/card_base/bean/crypto_setting_info.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<AssetSettingsState>? buildEffect() {
  return combineEffects(<Object, Effect<AssetSettingsState>>{
    Lifecycle.initState: _onInit,
    AssetSettingsAction.loadData: _onInit,
    AssetSettingsAction.sectionClick: _onSectionClick,
    AssetSettingsAction.itemClick: _onItemClick,
    AssetSettingsAction.saveClick: _onSaveClick,
  });
}

Future<void> _onInit(Action action, Context<AssetSettingsState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.cryptoSettingPageUrl, queryParameters: {'uid': ctx.state.uid,'isDefault':true});

  if (result.isSuccess) {
    List<dynamic> list = result.data['rows'];
    List<CryptoSettingInfo> packageList = list.map((e) => CryptoSettingInfo.fromJson(e)).toList();
    ctx.dispatch(AssetSettingsActionCreator.onLoadSuccess(packageList));
  } else {
    ctx.dispatch(AssetSettingsActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onSaveClick(Action action, Context<AssetSettingsState> ctx) async {
  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  List<Map<String,dynamic>> list = [];
  for(int i = 0;i< ctx.state.list.length;i++){
    final section = ctx.state.list[i];
    for(int j = 0;j< section.networks!.length;j++){
      final item = section.networks![j];
      list.add({'code':section.code,'network':item.networkId,'display':item.display??false});
    }
  }

  var result = await HttpManager.getInstance().post(NetworkAddress.updateCryptoSettingPageUrl,null, data: {'uid': ctx.state.uid,'settings':list});
  pr.hide();
  if (result.isSuccess) {
    Navigator.of(ctx.context).pop();
  } else {
    showToast(result.message);
  }
}

void _onSectionClick(Action action, Context<AssetSettingsState> ctx) {
  int sectionIndex = action.payload['index'];
  bool value = action.payload['value'];
  var list = ctx.state.list.toList();
  for (var e in list[sectionIndex].networks!) {
    e.display = value;
  }
  ctx.dispatch(AssetSettingsActionCreator.onUpdateList(list));

}

void _onItemClick(Action action, Context<AssetSettingsState> ctx) {
  int sectionIndex = action.payload['sectionIndex'];
  int index = action.payload['index'];
  bool value = action.payload['value'];
  var list = ctx.state.list.toList();
  list[sectionIndex].networks![index].display = value;
  ctx.dispatch(AssetSettingsActionCreator.onUpdateList(list));

}
