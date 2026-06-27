import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum CashOutAction {
  loadBankInfo,
  loadBankInfoSuccess,
  loadBankInfoFailure,
  refreshBankInfo,
  amountInput,
  fillAll,
  triggerFeeLoad, // 仅在 effect 中注册，避免与 amountInput/fillAll 双重注册
  loadFee,
  loadFeeSuccess,
  updateLoadingBank,
  updateLoadingFee,
  submit,
  updateSubmitting,
  pushBindBank,
}

class CashOutActionCreator {
  static Action onLoadBankInfo() => const Action(CashOutAction.loadBankInfo);

  static Action onLoadBankInfoSuccess(WithdrawBankInfo info) =>
      Action(CashOutAction.loadBankInfoSuccess, payload: info);

  static Action onLoadBankInfoFailure() =>
      const Action(CashOutAction.loadBankInfoFailure);

  static Action onRefreshBankInfo() =>
      const Action(CashOutAction.refreshBankInfo);

  static Action onAmountInput(String amount) =>
      Action(CashOutAction.amountInput, payload: amount);

  static Action onFillAll() => const Action(CashOutAction.fillAll);

  static Action onTriggerFeeLoad() =>
      const Action(CashOutAction.triggerFeeLoad);

  static Action onLoadFee() => const Action(CashOutAction.loadFee);

  static Action onLoadFeeSuccess(CashOutFeeInfo info) =>
      Action(CashOutAction.loadFeeSuccess, payload: info);

  static Action onUpdateLoadingBank(bool v) =>
      Action(CashOutAction.updateLoadingBank, payload: v);

  static Action onUpdateLoadingFee(bool v) =>
      Action(CashOutAction.updateLoadingFee, payload: v);

  static Action onSubmit() => const Action(CashOutAction.submit);

  static Action onUpdateSubmitting(bool v) =>
      Action(CashOutAction.updateSubmitting, payload: v);

  static Action onPushBindBank() => const Action(CashOutAction.pushBindBank);
}
