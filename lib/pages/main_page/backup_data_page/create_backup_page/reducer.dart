import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CreateBackupState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CreateBackupState>>{
      CreateBackupAction.action: _onAction,
    },
  );
}

CreateBackupState _onAction(CreateBackupState state, Action action) {
  final CreateBackupState newState = state.clone();
  return newState;
}
