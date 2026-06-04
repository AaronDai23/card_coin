import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SelectedActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SelectedActivateState>>{
      SelectedActivateAction.action: _onAction,
    },
  );
}

SelectedActivateState _onAction(SelectedActivateState state, Action action) {
  final SelectedActivateState newState = state.clone();
  return newState;
}
