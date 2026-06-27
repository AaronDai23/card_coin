import 'dart:async';

import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Timer? _feeDebounce;

Effect<CashOutState>? buildEffect() {
  return combineEffects(<Object, Effect<CashOutState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    CashOutAction.loadBankInfo: _onLoadBankInfo,
    CashOutAction.refreshBankInfo: _onLoadBankInfo,
    // amountInput / fillAll 不在此处注册——它们只走 reducer，
    // 防止 effect 吸收导致 reducer 不执行（fish_redux 机制）。
    // 防抖触发费用加载使用单独的 triggerFeeLoad action。
    CashOutAction.triggerFeeLoad: _onTriggerFeeLoad,
    CashOutAction.loadFee: _onLoadFee,
    CashOutAction.submit: _onSubmit,
    CashOutAction.pushBindBank: _onPushBindBank,
  });
}

void _onInit(Action action, Context<CashOutState> ctx) {
  ctx.dispatch(CashOutActionCreator.onLoadBankInfo());
}

void _onDispose(Action action, Context<CashOutState> ctx) {
  _feeDebounce?.cancel();
}

Future<void> _onLoadBankInfo(Action action, Context<CashOutState> ctx) async {
  ctx.dispatch(CashOutActionCreator.onUpdateLoadingBank(true));

  final result =
      await HttpManager.getInstance().get(NetworkAddress.withdrawBankCurrent);

  if (result.isSuccess && result.data is Map) {
    final info = WithdrawBankInfo.fromJson(
        Map<String, dynamic>.from(result.data as Map));
    ctx.dispatch(CashOutActionCreator.onLoadBankInfoSuccess(info));
  } else {
    ctx.dispatch(CashOutActionCreator.onLoadBankInfoFailure());
    showToast(result.message);
  }
}

void _onTriggerFeeLoad(Action action, Context<CashOutState> ctx) {
  // 防抖 600ms 后触发费用计算，amountInput/fillAll 已由 reducer 更新状态
  _feeDebounce?.cancel();
  _feeDebounce = Timer(const Duration(milliseconds: 600), () {
    ctx.dispatch(CashOutActionCreator.onLoadFee());
  });
}

Future<void> _onLoadFee(Action action, Context<CashOutState> ctx) async {
  final amount = ctx.state.inputAmount.trim();
  if (amount.isEmpty) return;

  ctx.dispatch(CashOutActionCreator.onUpdateLoadingFee(true));

  final result = await HttpManager.getInstance().post(
    NetworkAddress.cashOutFee,
    null,
    data: {
      'uid': ctx.state.uid,
      'symbol': ctx.state.symbol,
      'amount': amount,
    },
  );

  if (result.isSuccess && result.data is Map) {
    final info =
        CashOutFeeInfo.fromJson(Map<String, dynamic>.from(result.data as Map));
    ctx.dispatch(CashOutActionCreator.onLoadFeeSuccess(info));
  } else {
    ctx.dispatch(CashOutActionCreator.onUpdateLoadingFee(false));
  }
}

Future<void> _onSubmit(Action action, Context<CashOutState> ctx) async {
  final amount = ctx.state.inputAmount.trim();
  if (amount.isEmpty || double.tryParse(amount) == null) {
    showToast('Please enter a valid amount');
    return;
  }

  final bankInfo = ctx.state.bankInfo;
  if (bankInfo == null || !bankInfo.bound) {
    showToast('Please bind a bank account first');
    return;
  }

  final feeInfo = ctx.state.feeInfo;
  if (feeInfo != null && !feeInfo.canCashOut) {
    showToast('Insufficient balance');
    return;
  }

  ctx.dispatch(CashOutActionCreator.onUpdateSubmitting(true));

  final result = await HttpManager.getInstance().post(
    NetworkAddress.cashOutApply,
    null,
    data: {
      'uid': ctx.state.uid,
      'symbol': ctx.state.symbol,
      'amount': amount,
    },
  );

  ctx.dispatch(CashOutActionCreator.onUpdateSubmitting(false));

  if (result.isSuccess) {
    showToast('Submitted successfully');
    Navigator.of(ctx.context).pop(true);
  } else {
    showToast(result.message);
  }
}

Future<void> _onPushBindBank(Action action, Context<CashOutState> ctx) async {
  final bankInfo = ctx.state.bankInfo;
  final result = await Navigator.of(ctx.context).pushNamed(
    'withdrawBankPage',
    arguments: {
      'bound': bankInfo?.bound ?? false,
      'bankInfo': bankInfo,
    },
  );
  if (result == true) {
    ctx.dispatch(CashOutActionCreator.onRefreshBankInfo());
  }
}
