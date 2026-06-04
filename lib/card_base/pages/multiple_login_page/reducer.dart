import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<MultipleLoginState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MultipleLoginState>>{
      MultipleLoginAction.updateLoginType: _onUpdateLoginType,
      MultipleLoginAction.loadSuccess: _onLoadSuccess,
      MultipleLoginAction.loadFailure: _onLoadFailure,
      MultipleLoginAction.showLoading: _onShowLoading,
    },
  );
}

MultipleLoginState _onUpdateLoginType(MultipleLoginState state, Action action) {
  final MultipleLoginState newState = state.clone()
    ..currentIndex = action.payload;
  return newState;
}

MultipleLoginState _onLoadSuccess(MultipleLoginState state, Action action) {
  final MultipleLoginState newState = state.clone()
    ..loginMethodList = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MultipleLoginState _onLoadFailure(MultipleLoginState state, Action action) {
  final MultipleLoginState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MultipleLoginState _onShowLoading(MultipleLoginState state, Action action) {
  final MultipleLoginState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
