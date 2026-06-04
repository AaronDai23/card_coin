
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<SetPasswordState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SetPasswordState>>{
      SetPasswordAction.loadSuccess: _onLoadSuccess,
      SetPasswordAction.loadFailure: _onLoadFailure,
      SetPasswordAction.showLoading: _onShowLoading,
      SetPasswordAction.updateMethodIndex: _onUpdateMethodIndex,
    },
  );
}


SetPasswordState _onLoadSuccess(SetPasswordState state, Action action) {
  final SetPasswordState newState = state.clone()..verifyMethods = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

SetPasswordState _onLoadFailure(SetPasswordState state, Action action) {
  final SetPasswordState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

SetPasswordState _onShowLoading(SetPasswordState state, Action action) {
  final SetPasswordState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

SetPasswordState _onUpdateMethodIndex(SetPasswordState state, Action action) {
  final SetPasswordState newState = state.clone()..index = action.payload;
  return newState;
}
