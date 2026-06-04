import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AddBlessState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AddBlessState>>{
      AddBlessAction.updateRemain: _updateRemain,
      AddBlessAction.updateResults: reducer,
      AddBlessAction.updateLoading: reducer,
    },
  );
}

AddBlessState _updateRemain(AddBlessState state, Action action) {
  final newState = state.clone();
  newState.remainCount = action.payload;
  return newState;
}

AddBlessState reducer(AddBlessState state, Action action) {
  final AddBlessState newState = state.clone();
  switch (action.type) {
    case AddBlessAction.updateResults:
      newState.searchResults = action.payload;
      return newState;
    case AddBlessAction.updateLoading:
      newState.isLoading = action.payload;
      return newState;
    default:
      return state;
  }
}
