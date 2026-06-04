import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;

import '../selected_activate_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<PackageActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<PackageActivateState>>{
    Lifecycle.initState: _onInit,
    PackageActivateAction.loadData: _onLoadData,
    PackageActivateAction.checkClick: _onCheckClick,
    PackageActivateAction.activateClick: _onActivateClick,
    SelectedActivateAction.cardActivateChanged: _onRefresh,
  });
}

Future<void> _onInit(Action action, Context<PackageActivateState> ctx) async {
  ctx.dispatch(PackageActivateActionCreator.onLoadData());
}

Future<void> _onRefresh(
    Action action, Context<PackageActivateState> ctx) async {
  ctx.dispatch(PackageActivateActionCreator.onShowLoading());
  ctx.dispatch(PackageActivateActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<PackageActivateState> ctx) async {
  var result = await HttpManager.getInstance().get(
      NetworkAddress.activatePackageSummaryUrl,
      queryParameters: {'uid': ctx.state.uid});
  ActivatePackageSummary activateSummary;
  if (result.isSuccess) {
    activateSummary = ActivatePackageSummary.fromJson(result.data);
    // ctx.dispatch(SingleActivateActionCreator.onLoadSuccess(activateSummary));
  } else {
    ctx.dispatch(PackageActivateActionCreator.onLoadFailure(result.message));
    return;
  }

  result = await HttpManager.getInstance().get(
      NetworkAddress.activatePackagePageUrl,
      queryParameters: {'uid': ctx.state.uid});
  if (result.isSuccess) {
    List<dynamic> list = result.data['rows'];
    List<CardPackage> packageList =
        list.map((e) => CardPackage.fromJson(e)).toList();
    if (ctx.state.selectedList.isNotEmpty) {
      ctx.state.selectedList.removeWhere((element) =>
          packageList[element].packageActiveCount! >=
          packageList[element].totalPackageCount!);
    }
    ctx.dispatch(PackageActivateActionCreator.onLoadSuccess(
        activateSummary, packageList));
  } else {
    ctx.dispatch(PackageActivateActionCreator.onLoadFailure(result.message));
  }
}

void _onCheckClick(Action action, Context<PackageActivateState> ctx) {
  int index = action.payload;
  var list = ctx.state.selectedList.toList();
  if (list.contains(index)) {
    list.remove(index);
  } else {
    list.add(index);
  }
  ctx.dispatch(PackageActivateActionCreator.onUpdateSelectedList(list));
}

Future<void> _onActivateClick(
    Action action, Context<PackageActivateState> ctx) async {
  final list = ctx.state.selectedList.toList();
  list.sort((a, b) => a.compareTo(b));
  final packageList = list.map((e) => ctx.state.packageList[e]).toList();
  var result = await Navigator.of(ctx.context).pushNamed('selectedActivatePage',
      arguments: {'uid': ctx.state.uid, 'packageList': packageList});
  if (result == true) {
    ctx.dispatch(PackageActivateActionCreator.onShowLoading());
    _onInit(action, ctx);
  }
}
