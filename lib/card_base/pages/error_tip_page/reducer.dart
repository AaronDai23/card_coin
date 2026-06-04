import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ErrorTipState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ErrorTipState>>{
      ErrorTipAction.action: _onAction,
    },
  );
}

ErrorTipState _onAction(ErrorTipState state, Action action) {
  final ErrorTipState newState = state.clone();
  return newState;
}
