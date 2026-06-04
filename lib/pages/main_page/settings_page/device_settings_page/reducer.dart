import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DeviceSettingsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<DeviceSettingsState>>{
      DeviceSettingsAction.action: _onAction,
      DeviceSettingsAction.updateImage: _onupdateViewAction,
    },
  );
}

DeviceSettingsState _onAction(DeviceSettingsState state, Action action) {
  final DeviceSettingsState newState = state.clone();
  return newState;
}

DeviceSettingsState _onupdateViewAction(
    DeviceSettingsState state, Action action) {
  final DeviceSettingsState newState = state.clone();
  return newState;
}
