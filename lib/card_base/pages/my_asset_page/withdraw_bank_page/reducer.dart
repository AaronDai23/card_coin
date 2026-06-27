import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WithdrawBankState>? buildReducer() {
  return asReducer(<Object, Reducer<WithdrawBankState>>{
    WithdrawBankAction.updateLoadingBanks: _onUpdateLoadingBanks,
    WithdrawBankAction.loadBanksSuccess: _onLoadBanksSuccess,
    WithdrawBankAction.loadBanksFailure: _onLoadBanksFailure,
    WithdrawBankAction.selectBank: _onSelectBank,
    WithdrawBankAction.updateCardHolder: _onUpdateCardHolder,
    WithdrawBankAction.updateCardNo: _onUpdateCardNo,
    WithdrawBankAction.updateSubmitting: _onUpdateSubmitting,
  });
}

WithdrawBankState _onUpdateLoadingBanks(
        WithdrawBankState state, Action action) =>
    state.clone()..isLoadingBanks = action.payload as bool;

WithdrawBankState _onLoadBanksSuccess(WithdrawBankState state, Action action) {
  final list = action.payload as List<BankItem>;
  final newState = state.clone()
    ..bankList = list
    ..isLoadingBanks = false;
  // 如果已有选中 bankCode，保留；否则默认选第一个
  if (newState.selectedBankCode.isEmpty && list.isNotEmpty) {
    newState.selectedBankCode = list[0].bankCode;
    newState.selectedBankName = list[0].bankName;
  }
  return newState;
}

WithdrawBankState _onLoadBanksFailure(WithdrawBankState state, Action action) =>
    state.clone()..isLoadingBanks = false;

WithdrawBankState _onSelectBank(WithdrawBankState state, Action action) {
  final bank = action.payload as BankItem;
  return state.clone()
    ..selectedBankCode = bank.bankCode
    ..selectedBankName = bank.bankName;
}

WithdrawBankState _onUpdateCardHolder(WithdrawBankState state, Action action) =>
    state.clone()..cardHolder = action.payload as String;

WithdrawBankState _onUpdateCardNo(WithdrawBankState state, Action action) =>
    state.clone()..cardNo = action.payload as String;

WithdrawBankState _onUpdateSubmitting(WithdrawBankState state, Action action) =>
    state.clone()..isSubmitting = action.payload as bool;
