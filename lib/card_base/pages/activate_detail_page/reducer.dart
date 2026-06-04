import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ActivateDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ActivateDetailState>>{
      ActivateDetailAction.action: _onAction,
      ActivateDetailAction.updateTitle: _onUpdateTitle,
    },
  );
}

ActivateDetailState _onAction(ActivateDetailState state, Action action) {
  final ActivateDetailState newState = state.clone();
  return newState;
}

ActivateDetailState _onUpdateTitle(ActivateDetailState state, Action action) {
  final ActivateDetailState newState = state.clone()..title = action.payload;
  return newState;
}
