import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../utils/scan_util.dart';
import 'action.dart';
import 'state.dart';

Effect<ActivateDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<ActivateDetailState>>{
    Lifecycle.initState: _onInit,
    ActivateDetailAction.action: _onAction,
    ActivateDetailAction.activateClick: _onActivateClick,
  });
}

void _onAction(Action action, Context<ActivateDetailState> ctx) {}

void _onInit(Action action, Context<ActivateDetailState> ctx) {
  if (ctx.state.title == null) {
    HttpManager.getInstance()
        .get(NetworkAddress.getCardActivationTitle)
        .then((result) {
      if (result.isSuccess) {
        if (result.data != null) {
          final name = result.data['name'] ?? '';
          ctx.dispatch(ActivateDetailActionCreator.onUpdateTitle(name));
        }
      }
    });
  }
}

Future<void> _onActivateClick(
    Action action, Context<ActivateDetailState> ctx) async {
  if (ctx.state.uuid != null) {
    Navigator.of(ctx.context).pushReplacementNamed('deviceActivatePage',
        arguments: {'uuid': ctx.state.uuid, 'title': ctx.state.title});
  } else {
    final scanResponse = await ScanUtil.chipScanOnly();
    if (scanResponse.isSuccess) {
      String uuid = scanResponse.data;
      Navigator.of(ctx.context).pushReplacementNamed('deviceActivatePage',
          arguments: {'uuid': uuid, 'title': ctx.state.title});
    } else {
      if (scanResponse.message != null &&
          scanResponse.message!.isNotEmpty &&
          scanResponse.message!.length < 100) {
        showToast(scanResponse.message!);
      }
      // if (scanResponse.message != "Session invalidated by user") {
      //   showToast(scanResponse.message ?? '');
      // }
    }
  }
}
