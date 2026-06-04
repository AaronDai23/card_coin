import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PhoneActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PhoneActivateState>>{
      PhoneActivateAction.action: _onAction,
    },
  );
}

PhoneActivateState _onAction(PhoneActivateState state, Action action) {
  final PhoneActivateState newState = state.clone();
  return newState;
}
