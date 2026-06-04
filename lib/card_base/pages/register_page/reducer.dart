import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RegisterState>? buildReducer() {
  return asReducer(
    <Object, Reducer<RegisterState>>{
      RegisterAction.updateAgree: _onUpdateAgree,
      RegisterAction.loadSuccess: _onLoadSuccess,
      RegisterAction.loadFailed: _onLoadFailed,
      RegisterAction.changeType: _onChangeType
    },
  );
}

RegisterState _onUpdateAgree(RegisterState state, Action action) {
  final RegisterState newState = state.clone()..isAgree = action.payload;
  return newState;
}

RegisterState _onChangeType(RegisterState state, Action action) {
  final RegisterState newState = state.clone()..currentIndex = action.payload;
  return newState;
}

RegisterState _onLoadSuccess(RegisterState state, Action action) {
  final RegisterState newState = state.clone()
    ..registerMethodList = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

RegisterState _onLoadFailed(RegisterState state, Action action) {
  final RegisterState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}
