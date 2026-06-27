import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ExchangeState>? buildReducer() {
  return asReducer(<Object, Reducer<ExchangeState>>{
    ExchangeAction.updateLoadingFrom: _onUpdateLoadingFrom,
    ExchangeAction.loadInitSuccess: _onLoadInitSuccess,
    ExchangeAction.loadInitFailure: _onLoadInitFailure,
    ExchangeAction.selectFrom: _onSelectFrom,
    ExchangeAction.applyFromSelection: _onSelectFrom,
    ExchangeAction.updateLoadingTo: _onUpdateLoadingTo,
    ExchangeAction.loadTargetSuccess: _onLoadTargetSuccess,
    ExchangeAction.loadTargetFailure: _onLoadTargetFailure,
    ExchangeAction.selectTo: _onSelectTo,
    ExchangeAction.updateLoadingRate: _onUpdateLoadingRate,
    ExchangeAction.loadPriceSuccess: _onLoadPriceSuccess,
    ExchangeAction.amountChanged: _onAmountChanged,
    ExchangeAction.updateLoadingPreview: _onUpdateLoadingPreview,
    ExchangeAction.loadPreviewSuccess: _onLoadPreviewSuccess,
    ExchangeAction.loadPreviewFailure: _onLoadPreviewFailure,
    ExchangeAction.updateSubmitting: _onUpdateSubmitting,
  });
}

ExchangeState _onUpdateLoadingFrom(ExchangeState state, Action action) =>
    state.clone()..isLoadingFrom = action.payload as bool;

ExchangeState _onLoadInitSuccess(ExchangeState state, Action action) {
  final list = action.payload as List<ExchangeFromItem>;
  return state.clone()
    ..fromList = list
    ..selectedFromIndex = 0
    ..isLoadingFrom = false
    ..toList = []
    ..selectedToIndex = 0
    ..rate = ''
    ..estimatedToAmount = '';
}

ExchangeState _onLoadInitFailure(ExchangeState state, Action action) =>
    state.clone()..isLoadingFrom = false;

ExchangeState _onSelectFrom(ExchangeState state, Action action) {
  final index = action.payload as int;
  return state.clone()
    ..selectedFromIndex = index
    ..inputAmount = ''
    ..estimatedToAmount = ''
    ..previewEstimated = ''
    ..previewFeeDisplay = ''
    ..previewReceived = '';
}

ExchangeState _onUpdateLoadingTo(ExchangeState state, Action action) =>
    state.clone()..isLoadingTo = action.payload as bool;

ExchangeState _onLoadTargetSuccess(ExchangeState state, Action action) {
  final list = action.payload as List<ExchangeToItem>;
  return state.clone()
    ..toList = list
    ..selectedToIndex = 0
    ..isLoadingTo = false
    ..rate = ''
    ..estimatedToAmount = '';
}

ExchangeState _onLoadTargetFailure(ExchangeState state, Action action) =>
    state.clone()..isLoadingTo = false;

ExchangeState _onSelectTo(ExchangeState state, Action action) {
  final index = action.payload as int;
  return state.clone()
    ..selectedToIndex = index
    ..rate = ''
    ..estimatedToAmount = '';
}

ExchangeState _onUpdateLoadingRate(ExchangeState state, Action action) =>
    state.clone()..isLoadingRate = action.payload as bool;

ExchangeState _onLoadPriceSuccess(ExchangeState state, Action action) {
  final data = action.payload as Map<String, dynamic>;
  final newRate = data['rate']?.toString() ?? '';
  final updatedAt = data['updatedAt']?.toString() ?? '';
  final r = double.tryParse(newRate);
  final input = double.tryParse(state.inputAmount);
  final estimated =
      (r != null && input != null) ? (input * r).toStringAsFixed(6) : '';
  return state.clone()
    ..rate = newRate
    ..rateUpdatedAt = updatedAt
    ..isLoadingRate = false
    ..estimatedToAmount = estimated;
}

ExchangeState _onAmountChanged(ExchangeState state, Action action) {
  String input = action.payload as String;
  double? amount = double.tryParse(input);

  // 超出可用余额时截断到余额上限
  final balance = double.tryParse(state.selectedFrom?.balance ?? '');
  if (amount != null && balance != null && amount > balance) {
    input = state.selectedFrom!.balance;
    amount = balance;
  }

  final r = double.tryParse(state.rate);
  final estimated =
      (r != null && amount != null) ? (amount * r).toStringAsFixed(6) : '';
  return state.clone()
    ..inputAmount = input
    ..estimatedToAmount = estimated;
}

ExchangeState _onUpdateLoadingPreview(ExchangeState state, Action action) =>
    state.clone()..isLoadingPreview = action.payload as bool;

ExchangeState _onLoadPreviewSuccess(ExchangeState state, Action action) {
  final data = action.payload as Map<String, dynamic>;
  final estimated = data['estimatedToAmount']?.toString() ?? '';
  final fee = data['fee']?.toString() ?? '';
  final feeSymbol = data['feeSymbol']?.toString() ?? '';
  final toCode = state.selectedTo?.code ?? '';

  String received = estimated;
  if (feeSymbol == toCode &&
      fee.isNotEmpty &&
      fee != '0' &&
      estimated.isNotEmpty) {
    final e = double.tryParse(estimated);
    final f = double.tryParse(fee);
    if (e != null && f != null) {
      received = (e - f)
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }

  final feeDisplay = (fee.isNotEmpty && fee != '0') ? '$fee $feeSymbol' : '';

  return state.clone()
    ..isLoadingPreview = false
    ..previewEstimated = estimated
    ..previewFeeDisplay = feeDisplay
    ..previewReceived = received;
}

ExchangeState _onLoadPreviewFailure(ExchangeState state, Action action) =>
    state.clone()
      ..isLoadingPreview = false
      ..previewEstimated = ''
      ..previewFeeDisplay = ''
      ..previewReceived = '';

ExchangeState _onUpdateSubmitting(ExchangeState state, Action action) =>
    state.clone()..isSubmitting = action.payload as bool;
