import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UnlockPinCodeState>? buildReducer() {
  return asReducer(
    <Object, Reducer<UnlockPinCodeState>>{
      UnlockPinCodeAction.action: _onAction,
    },
  );
}

UnlockPinCodeState _onAction(UnlockPinCodeState state, Action action) {
  final UnlockPinCodeState newState = state.clone();
  return newState;
}
