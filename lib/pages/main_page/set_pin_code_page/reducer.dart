import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SetPinCodeState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SetPinCodeState>>{
      SetPinCodeAction.action: _onAction,
    },
  );
}

SetPinCodeState _onAction(SetPinCodeState state, Action action) {
  final SetPinCodeState newState = state.clone();
  return newState;
}
