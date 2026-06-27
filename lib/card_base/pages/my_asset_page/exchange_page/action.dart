import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum ExchangeAction {
  loadInit,
  loadInitSuccess,
  loadInitFailure,
  selectFrom,
  applyFromSelection,
  loadTargetSuccess,
  loadTargetFailure,
  selectTo,
  refreshPrice,
  loadPriceSuccess,
  updateLoadingFrom,
  updateLoadingTo,
  updateLoadingRate,
  amountChanged,
  stepFrom,
  stepTo,
  setAllFrom,
  setAllTo,
  updateLoadingPreview,
  loadPreviewSuccess,
  loadPreviewFailure,
  submit,
  updateSubmitting,
  requestPreview,
}

class ExchangeActionCreator {
  static Action onLoadInit() => const Action(ExchangeAction.loadInit);

  static Action onLoadInitSuccess(List<ExchangeFromItem> list) =>
      Action(ExchangeAction.loadInitSuccess, payload: list);

  static Action onLoadInitFailure() =>
      const Action(ExchangeAction.loadInitFailure);

  static Action onSelectFrom(int index) =>
      Action(ExchangeAction.selectFrom, payload: index);

  static Action onApplyFromSelection(int index) =>
      Action(ExchangeAction.applyFromSelection, payload: index);

  static Action onLoadTargetSuccess(List<ExchangeToItem> list) =>
      Action(ExchangeAction.loadTargetSuccess, payload: list);

  static Action onLoadTargetFailure() =>
      const Action(ExchangeAction.loadTargetFailure);

  static Action onSelectTo(int index) =>
      Action(ExchangeAction.selectTo, payload: index);

  static Action onRefreshPrice() => const Action(ExchangeAction.refreshPrice);

  static Action onLoadPriceSuccess(Map<String, dynamic> data) =>
      Action(ExchangeAction.loadPriceSuccess, payload: data);

  static Action onUpdateLoadingFrom(bool v) =>
      Action(ExchangeAction.updateLoadingFrom, payload: v);

  static Action onUpdateLoadingTo(bool v) =>
      Action(ExchangeAction.updateLoadingTo, payload: v);

  static Action onUpdateLoadingRate(bool v) =>
      Action(ExchangeAction.updateLoadingRate, payload: v);

  static Action onAmountChanged(String amount) =>
      Action(ExchangeAction.amountChanged, payload: amount);

  static Action onStepFrom(int direction) =>
      Action(ExchangeAction.stepFrom, payload: direction);

  static Action onStepTo(int direction) =>
      Action(ExchangeAction.stepTo, payload: direction);

  static Action onSetAllFrom() => const Action(ExchangeAction.setAllFrom);

  static Action onSetAllTo() => const Action(ExchangeAction.setAllTo);

  static Action onUpdateLoadingPreview(bool v) =>
      Action(ExchangeAction.updateLoadingPreview, payload: v);

  static Action onLoadPreviewSuccess(Map<String, dynamic> data) =>
      Action(ExchangeAction.loadPreviewSuccess, payload: data);

  static Action onLoadPreviewFailure() =>
      const Action(ExchangeAction.loadPreviewFailure);

  static Action onSubmit() => const Action(ExchangeAction.submit);

  static Action onUpdateSubmitting(bool v) =>
      Action(ExchangeAction.updateSubmitting, payload: v);

  static Action onRequestPreview() =>
      const Action(ExchangeAction.requestPreview);
}
