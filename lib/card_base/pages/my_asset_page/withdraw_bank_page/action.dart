import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum WithdrawBankAction {
  loadBanks,
  loadBanksSuccess,
  loadBanksFailure,
  selectBank,
  updateCardHolder,
  updateCardNo,
  updateLoadingBanks,
  updateSubmitting,
  submit,
}

class WithdrawBankActionCreator {
  static Action onLoadBanks() => const Action(WithdrawBankAction.loadBanks);

  static Action onLoadBanksSuccess(List<BankItem> list) =>
      Action(WithdrawBankAction.loadBanksSuccess, payload: list);

  static Action onLoadBanksFailure() =>
      const Action(WithdrawBankAction.loadBanksFailure);

  static Action onSelectBank(BankItem bank) =>
      Action(WithdrawBankAction.selectBank, payload: bank);

  static Action onUpdateCardHolder(String v) =>
      Action(WithdrawBankAction.updateCardHolder, payload: v);

  static Action onUpdateCardNo(String v) =>
      Action(WithdrawBankAction.updateCardNo, payload: v);

  static Action onUpdateLoadingBanks(bool v) =>
      Action(WithdrawBankAction.updateLoadingBanks, payload: v);

  static Action onUpdateSubmitting(bool v) =>
      Action(WithdrawBankAction.updateSubmitting, payload: v);

  static Action onSubmit() => const Action(WithdrawBankAction.submit);
}
