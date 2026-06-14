import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CleanCacheState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CleanCacheState>>{
      CleanCacheAction.action: _onAction,
      CleanCacheAction.updateClearing: _onUpdateClearing,
    },
  );
}

CleanCacheState _onAction(CleanCacheState state, Action action) {
  final CleanCacheState newState = state.clone();
  return newState;
}

CleanCacheState _onUpdateClearing(CleanCacheState state, Action action) {
  final CleanCacheState newState = state.clone()..isClearing = action.payload;
  return newState;
}
