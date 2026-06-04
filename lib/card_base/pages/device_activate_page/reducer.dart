import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DeviceActivateState>? buildReducer() {
  return asReducer(
    <Object, Reducer<DeviceActivateState>>{
      DeviceActivateAction.action: _onAction,
      DeviceActivateAction.loadSuccess: _onLoadSuccess,
      DeviceActivateAction.loadFailure: _onLoadFailure,
      DeviceActivateAction.showLoading: _onShowLoading,
      DeviceActivateAction.changeType: _onChangeType
    },
  );
}

DeviceActivateState _onAction(DeviceActivateState state, Action action) {
  final DeviceActivateState newState = state.clone();
  return newState;
}
DeviceActivateState _onLoadSuccess(DeviceActivateState state, Action action) {
  final DeviceActivateState newState = state.clone()
    ..validateMethodList = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}
DeviceActivateState _onLoadFailure(DeviceActivateState state, Action action) {
  final DeviceActivateState newState = state.clone()..loadStatus = LoadType.loadFailure;
  return newState;
}
DeviceActivateState _onShowLoading(DeviceActivateState state, Action action) {
  final DeviceActivateState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

DeviceActivateState _onChangeType(DeviceActivateState state, Action action) {
  final DeviceActivateState newState = state.clone()..currentIndex = action.payload;
  return newState;
}
