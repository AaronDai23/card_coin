import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SettingsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SettingsState>>{
      SettingsAction.loadSuccess: _onLoadSuccess,
      SettingsAction.loadFailure: _onLoadFailure,
      SettingsAction.showLoading: _onShowLoading,
      // SettingsAction.updateSettingList: _onUpdateSettingList,
    },
  );
}

SettingsState _onLoadSuccess(SettingsState state, Action action) {
  final SettingsState newState = state.clone()
    ..list = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

SettingsState _onLoadFailure(SettingsState state, Action action) {
  final SettingsState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

SettingsState _onShowLoading(SettingsState state, Action action) {
  final SettingsState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

// SettingsState _onUpdateSettingList(SettingsState state, Action action) {
//   final SettingsState newState = state.clone()..settingList = action.payload;
//   return newState;
// }
