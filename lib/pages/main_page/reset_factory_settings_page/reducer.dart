import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ResetFactorySettingsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ResetFactorySettingsState>>{
      ResetFactorySettingsAction.action: _onAction,
      ResetFactorySettingsAction.onUpdateCheck: _onUpdateCheck,
      ResetFactorySettingsAction.onUpdateScanned: _onUpdateScanned,
      ResetFactorySettingsAction.onUpdateCount: _onUpdateCount,
    },
  );
}

ResetFactorySettingsState _onAction(
    ResetFactorySettingsState state, Action action) {
  final ResetFactorySettingsState newState = state.clone();
  return newState;
}

ResetFactorySettingsState _onUpdateCheck(
    ResetFactorySettingsState state, Action action) {
  final ResetFactorySettingsState newState = state.clone()
    ..check = action.payload;
  return newState;
}

ResetFactorySettingsState _onUpdateScanned(
    ResetFactorySettingsState state, Action action) {
  final ResetFactorySettingsState newState = state.clone()
    ..scanned = action.payload;
  return newState;
}

ResetFactorySettingsState _onUpdateCount(
    ResetFactorySettingsState state, Action action) {
  print("_onUpdateCount");
  final ResetFactorySettingsState newState = state.clone()
    ..count = action.payload;
  return newState;
}
