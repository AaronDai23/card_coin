import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Action;
import '../../bean/validate_method.dart';
import '../../widgets/show_zengge_bottom_sheet.dart';
import 'action.dart';
import 'state.dart';

Effect<DeviceActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<DeviceActivateState>>{
    Lifecycle.initState: _onInit,
    DeviceActivateAction.action: _onAction,
    DeviceActivateAction.showMethodList: _onShowMethodList,
  });
}

Future<void> _onInit(Action action, Context<DeviceActivateState> ctx) async {
  var result = await HttpManager.getInstance().get(NetworkAddress.validateMethodUrl);
  if (result.isSuccess) {
    List<dynamic> list = result.data;
    List<ValidateMethod> validateMethodList = list.map((e) => ValidateMethod.fromJson(e)).toList();
    validateMethodList.retainWhere((element) => element.status == 'ACTIVE');
    validateMethodList.sort((a, b) => a.seq!.compareTo(b.seq!));
    ctx.dispatch(DeviceActivateActionCreator.onLoadSuccess(validateMethodList));
  } else {
    ctx.dispatch(DeviceActivateActionCreator.onLoadFailure(result.message));
  }
}

void _onAction(Action action, Context<DeviceActivateState> ctx) {}

Future<void> _onShowMethodList(Action action, Context<DeviceActivateState> ctx) async {
  var index = await showMenuSelectBottomSheet(
      context: ctx.context,
      isCheck: ctx.state.currentIndex,
      list: ctx.state.validateMethodList!.mapIndexed((index, e) {
        var item = ctx.state.validateMethodList![index];
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
    ctx.dispatch(DeviceActivateActionCreator.onChangeType(index));
  }
}
