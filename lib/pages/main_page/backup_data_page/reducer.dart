import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BackupDataState>? buildReducer() {
  return asReducer(
    <Object, Reducer<BackupDataState>>{
      BackupDataAction.action: _onAction,
    },
  );
}

BackupDataState _onAction(BackupDataState state, Action action) {
  final BackupDataState newState = state.clone();
  return newState;
}
