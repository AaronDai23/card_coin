import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ResetCardDialogState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ResetCardDialogState>>{
      ResetCardDialogAction.onUpdateCount: _onUpdateCount,
      ResetCardDialogAction.onUpdateScanned: _onUpdateScanned,
      ResetCardDialogAction.onUpdateShowInput: _onUpdateShowInput,
      ResetCardDialogAction.onUpdateCardNo: _onUpdateCardNo,
    },
  );
}

ResetCardDialogState _onUpdateCount(ResetCardDialogState state, Action action) {
  final ResetCardDialogState newState = state.clone()..count = action.payload;
  return newState;
}

ResetCardDialogState _onUpdateScanned(
    ResetCardDialogState state, Action action) {
  final ResetCardDialogState newState = state.clone()..scanned = action.payload;
  return newState;
}

ResetCardDialogState _onUpdateShowInput(
    ResetCardDialogState state, Action action) {
  final ResetCardDialogState newState = state.clone()
    ..showPwdInput = action.payload;
  return newState;
}

ResetCardDialogState _onUpdateCardNo(
    ResetCardDialogState state, Action action) {
  final ResetCardDialogState newState = state.clone()..cardNo = action.payload;
  return newState;
}
