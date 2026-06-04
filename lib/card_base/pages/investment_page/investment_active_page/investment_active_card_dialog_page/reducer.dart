import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentActiveCardDialogState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentActiveCardDialogState>>{
      InvestmentActiveCardDialogAction.action: _onAction,
      InvestmentActiveCardDialogAction.onUpdateCount: _onUpdateCount,
      InvestmentActiveCardDialogAction.onUpdateScanned: _onUpdateScanned,
      InvestmentActiveCardDialogAction.onUpdateShowInput: _onUpdateShowInput,
    },
  );
}

InvestmentActiveCardDialogState _onAction(
    InvestmentActiveCardDialogState state, Action action) {
  final InvestmentActiveCardDialogState newState = state.clone();
  return newState;
}

InvestmentActiveCardDialogState _onUpdateCount(
    InvestmentActiveCardDialogState state, Action action) {
  final InvestmentActiveCardDialogState newState = state.clone()
    ..count = action.payload;
  return newState;
}

InvestmentActiveCardDialogState _onUpdateScanned(
    InvestmentActiveCardDialogState state, Action action) {
  final InvestmentActiveCardDialogState newState = state.clone()
    ..scanned = action.payload;
  return newState;
}

InvestmentActiveCardDialogState _onUpdateShowInput(
    InvestmentActiveCardDialogState state, Action action) {
  final InvestmentActiveCardDialogState newState = state.clone()
    ..showPwdInput = action.payload;
  return newState;
}
