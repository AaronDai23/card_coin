import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditAddressBookState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EditAddressBookState>>{
      EditAddressBookAction.action: _onAction,
    },
  );
}

EditAddressBookState _onAction(EditAddressBookState state, Action action) {
  final EditAddressBookState newState = state.clone();
  return newState;
}
