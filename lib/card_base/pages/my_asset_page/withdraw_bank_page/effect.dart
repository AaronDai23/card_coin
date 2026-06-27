import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

Effect<WithdrawBankState>? buildEffect() {
  return combineEffects(<Object, Effect<WithdrawBankState>>{
    Lifecycle.initState: _onInit,
    WithdrawBankAction.loadBanks: _onLoadBanks,
    WithdrawBankAction.submit: _onSubmit,
  });
}

void _onInit(Action action, Context<WithdrawBankState> ctx) {
  ctx.dispatch(WithdrawBankActionCreator.onLoadBanks());
}

Future<void> _onLoadBanks(Action action, Context<WithdrawBankState> ctx) async {
  ctx.dispatch(WithdrawBankActionCreator.onUpdateLoadingBanks(true));

  final result =
      await HttpManager.getInstance().get(NetworkAddress.withdrawBankBanks);

  if (result.isSuccess && result.data is List) {
    final list = (result.data as List)
        .map((e) => BankItem.fromJson(e as Map<String, dynamic>))
        .toList();
    ctx.dispatch(WithdrawBankActionCreator.onLoadBanksSuccess(list));
  } else {
    ctx.dispatch(WithdrawBankActionCreator.onLoadBanksFailure());
    showToast(result.message);
  }
}

Future<void> _onSubmit(Action action, Context<WithdrawBankState> ctx) async {
  final state = ctx.state;

  if (state.selectedBankCode.isEmpty) {
    showToast('Please select a bank');
    return;
  }
  if (state.cardHolder.trim().isEmpty) {
    showToast('Please enter the card holder name');
    return;
  }
  if (state.cardNo.trim().isEmpty) {
    showToast('Please enter the card number');
    return;
  }
  // 简单格式校验：仅数字，长度 6-20
  final cardNoClean = state.cardNo.trim();
  if (!RegExp(r'^\d{6,20}$').hasMatch(cardNoClean)) {
    showToast('Invalid card number format');
    return;
  }

  ctx.dispatch(WithdrawBankActionCreator.onUpdateSubmitting(true));

  final url = state.isEdit
      ? NetworkAddress.withdrawBankUpdate
      : NetworkAddress.withdrawBankBind;
  final result = await HttpManager.getInstance().post(
    url,
    null,
    data: {
      'bankCode': state.selectedBankCode,
      'cardNo': cardNoClean,
      'bankCardHolder': state.cardHolder.trim(),
    },
  );

  ctx.dispatch(WithdrawBankActionCreator.onUpdateSubmitting(false));

  if (result.isSuccess) {
    showToast(state.isEdit ? 'Updated successfully' : 'Bound successfully');
    Navigator.of(ctx.context).pop(true);
  } else {
    showToast(result.message);
  }
}
