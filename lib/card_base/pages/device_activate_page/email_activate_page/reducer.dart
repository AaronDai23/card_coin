import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EmailActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EmailActivateState>>{
      EmailActivateAction.action: _onAction,
      EmailActivateAction.updateStep: _onUpdateStep,
      EmailActivateAction.updateActivateInfo: _onUpdateActivateInfo,
    },
  );
}

EmailActivateState _onAction(EmailActivateState state, Action action) {
  final EmailActivateState newState = state.clone();
  return newState;
}

EmailActivateState _onUpdateStep(EmailActivateState state, Action action) {
  final EmailActivateState newState = state.clone()..step = action.payload;
  return newState;
}

EmailActivateState _onUpdateActivateInfo(EmailActivateState state, Action action) {
  final EmailActivateState newState = state.clone()..activateInfo = action.payload;
  return newState;
}
