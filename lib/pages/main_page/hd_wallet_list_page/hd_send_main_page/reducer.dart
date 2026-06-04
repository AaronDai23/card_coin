import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HdSendMainState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HdSendMainState>>{
      HdSendMainAction.action: _onAction,
    },
  );
}

HdSendMainState _onAction(HdSendMainState state, Action action) {
  final HdSendMainState newState = state.clone();
  return newState;
}
