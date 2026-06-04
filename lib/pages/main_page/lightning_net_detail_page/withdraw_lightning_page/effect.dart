import 'dart:async';

import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'package:oktoast/oktoast.dart';

import '../../../../pigeons/blockchain_platform_interface.dart';
import '../bean/lightning_sign_info.dart';
import '../light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';
import 'action.dart';
import 'state.dart';

Effect<WithdrawLightningState>? buildEffect() {
  return combineEffects(<Object, Effect<WithdrawLightningState>>{
    Lifecycle.initState: _onInit,
    WithdrawLightningAction.action: _onAction,
    WithdrawLightningAction.withdrawClick: _onWithdrawClick,
    WithdrawLightningAction.amountChanged: _onAmountChanged,
    WithdrawLightningAction.unitChanged: _onUnitChanged
  });
}

Future<void> _onInit(Action action, Context<WithdrawLightningState> ctx) async {
  Map<String, dynamic> parameters = {
    'code': 'BTC',
  };

  final invoiceResult = await HttpManager.getInstance()
      .get(NetworkAddress.getUnitsInfo, queryParameters: parameters);
  if (invoiceResult.isSuccess) {
    List? list = invoiceResult.data['unit'];
    List<UnitInfo> unitInfoList =
        list?.map((e) => UnitInfo.fromJson(e)).toList() ?? [];
    ctx.dispatch(WithdrawLightningActionCreator.onLoadSuccess(unitInfoList));
  } else {
    ctx.dispatch(
        WithdrawLightningActionCreator.onLoadFailed(invoiceResult.message));
  }
}

void _onAction(Action action, Context<WithdrawLightningState> ctx) {}

void _onAmountChanged(Action action, Context<WithdrawLightningState> ctx) {
  String value = action.payload;
  ctx.state.curValue = value;
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorTip = "";
    ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
    ctx.state.focusNode.requestFocus();
    return;
  }
  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! > 100000000000) {
      ctx.state.errorTip = "Enter number is too large";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
      ctx.state.focusNode.requestFocus();
      return;
    }
    if (double.tryParse(value)! <= 0) {
      ctx.state.errorTip = "Enter number is too small";
      ctx.state.mount = "";
      // setState(() {});
      ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
      ctx.state.focusNode.requestFocus();
      return;
    }

    if (value.contains(".")) {
      List list = value.split(".");
      String afterStr = list[1];
      if (afterStr.length > 7) {
        ctx.state.errorTip = "Enter number has too many decimal places";
        ctx.state.mount = "";
        // setState(() {});
        ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
        ctx.state.focusNode.requestFocus();
        return;
      }
    }

    double conversion = double.parse(ctx.state.usdtUnit!.conversion) /
        double.parse(ctx.state.selectedUnit!.conversion);

    ctx.state.mount =
        NumberUtils.getCountBetweenTwoNumber(value, conversion.toString(), 2);
    ctx.state.errorTip = "";
    // setState(() {});
    ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
    ctx.state.focusNode.requestFocus();
  } else {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
    // setState(() {});
    ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
    ctx.state.focusNode.requestFocus();
  }
}

void _onUnitChanged(Action action, Context<WithdrawLightningState> ctx) {
  UnitInfo unitInfo = action.payload;
  ctx.state.selectedUnit = unitInfo;
  _updateTipCount(action, ctx, ctx.state.curValue);
  ctx.dispatch(WithdrawLightningActionCreator.onUpdate());
}

Future<void> _onWithdrawClick(
    Action action, Context<WithdrawLightningState> ctx) async {
  if (ctx.state.curValue.isEmpty) {
    showToast('请输入金额');
    return;
  }
  if (double.tryParse(ctx.state.curValue)! < 0) {
    showToast('金额格式错误，请重新输入');
    return;
  }

  if (ctx.state.curValue.contains(".")) {
    List list = ctx.state.curValue.split(".");
    String afterStr = list[1];
    if (afterStr.length > 7) {
      showToast('金额格式错误，请重新输入');
      return;
    }
  }
  String newMount = ctx.state.curValue.replaceAll(',', '');

  final pr = ProgressDialog(ctx.context);
  await pr.show();
  try {
    final result = await _awaitWithTimeout(
      HttpManager.getInstance().post(
          NetworkAddress.lightningSignMessageUrl, null,
          data: {'uid': ctx.state.uid, 'signType': 'WITHDRAWAL'}),
      step: 'request signMessage',
      timeout: const Duration(seconds: 30),
    );

    if (!result.isSuccess) {
      showToast(result.message);
      return;
    }

    final signInfo = LightningSignInfo.fromJson(result.data);

    final signedHex = await _awaitWithTimeout(
      BlockchainPlatform.instance.signLightning(signInfo.signMessage, true),
      step: 'sdk signLightning',
      timeout: const Duration(seconds: 60),
    );

    final publicKey = await _awaitWithTimeout(
      BlockchainPlatform.instance.getBitcoinPublicKey(),
      step: 'sdk getBitcoinPublicKey',
      timeout: const Duration(seconds: 20),
    );

    final params = {
      'uid': ctx.state.uid,
      'signId': signInfo.signId,
      'publicKey': publicKey,
      'signResult': signedHex,
      'unit': ctx.state.selectedUnit!.symbol,
      'amount': newMount
    };

    final withdrawResult = await _awaitWithTimeout(
      HttpManager.getInstance()
          .post(NetworkAddress.lightningWithdrawUrl, null, data: params),
      step: 'request withdrawal',
      timeout: const Duration(seconds: 40),
    );

    if (withdrawResult.isSuccess) {
      await Future.delayed(const Duration(milliseconds: 200));
      await showDialog(
          context: ctx.context,
          builder: (context) {
            return const ZenggeTextAlertDialog('提现成功！');
          });

      Navigator.of(ctx.context).pop();
    } else {
      showToast(withdrawResult.message);
    }
  } on TimeoutException catch (e) {
    showToast(e.message ?? 'Request timeout, please retry.');
  } catch (error) {
    showToast(error.toString());
  } finally {
    pr.hide();
  }
}

Future<T> _awaitWithTimeout<T>(
  Future<T> future, {
  required String step,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final sw = Stopwatch()..start();
  try {
    final value = await future.timeout(timeout);
    print('[WithdrawLightning][$step] success in ${sw.elapsedMilliseconds}ms');
    return value;
  } on TimeoutException {
    print(
        '[WithdrawLightning][$step] timeout after ${sw.elapsedMilliseconds}ms');
    throw TimeoutException('$step timeout, please retry.');
  }
}

void _updateTipCount(
    Action action, Context<WithdrawLightningState> ctx, String value) {
  if (value.isEmpty) {
    ctx.state.mount = "";
    ctx.state.errorTip = "";
    return;
  }
  bool isDouble = double.tryParse(value) != null;
  if (isDouble) {
    if (double.tryParse(value)! > 100000000000) {
      ctx.state.errorTip = "Enter number is too large";
      ctx.state.mount = "";
      return;
    }
    if (double.tryParse(value)! <= 0) {
      ctx.state.errorTip = "Enter number is too small";
      ctx.state.mount = "";
      return;
    }

    double conversion = double.parse(ctx.state.usdtUnit!.conversion) /
        double.parse(ctx.state.selectedUnit!.conversion);
    ctx.state.mount =
        NumberUtils.getCountBetweenTwoNumber(value, conversion.toString(), 2);
    ctx.state.errorTip = "";
  } else {
    ctx.state.errorTip = "Please enter a valid number";
    ctx.state.mount = "";
  }
}
