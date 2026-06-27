import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CashOutState>? buildReducer() {
  return asReducer(<Object, Reducer<CashOutState>>{
    CashOutAction.updateLoadingBank: _onUpdateLoadingBank,
    CashOutAction.loadBankInfoSuccess: _onLoadBankInfoSuccess,
    CashOutAction.loadBankInfoFailure: _onLoadBankInfoFailure,
    CashOutAction.amountInput: _onAmountInput,
    CashOutAction.fillAll: _onFillAll,
    CashOutAction.updateLoadingFee: _onUpdateLoadingFee,
    CashOutAction.loadFeeSuccess: _onLoadFeeSuccess,
    CashOutAction.updateSubmitting: _onUpdateSubmitting,
  });
}

CashOutState _onUpdateLoadingBank(CashOutState state, Action action) =>
    state.clone()..isLoadingBank = action.payload as bool;

CashOutState _onLoadBankInfoSuccess(CashOutState state, Action action) =>
    state.clone()
      ..bankInfo = action.payload as WithdrawBankInfo
      ..isLoadingBank = false;

CashOutState _onLoadBankInfoFailure(CashOutState state, Action action) =>
    state.clone()..isLoadingBank = false;

CashOutState _onAmountInput(CashOutState state, Action action) =>
    state.clone()..inputAmount = action.payload as String;

CashOutState _onFillAll(CashOutState state, Action action) =>
    state.clone()..inputAmount = state.balance;

CashOutState _onUpdateLoadingFee(CashOutState state, Action action) =>
    state.clone()..isLoadingFee = action.payload as bool;

CashOutState _onLoadFeeSuccess(CashOutState state, Action action) {
  final info = action.payload as CashOutFeeInfo;
  return state.clone()
    ..feeInfo = info
    ..balance = info.availableBalance // 用 fee API 返回值更新余额
    ..isLoadingFee = false;
}

CashOutState _onUpdateSubmitting(CashOutState state, Action action) =>
    state.clone()..isSubmitting = action.payload as bool;
