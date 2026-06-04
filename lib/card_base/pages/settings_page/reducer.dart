import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<SettingsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SettingsState>>{
      SettingsAction.loadSuccess: _onLoadSuccess,
      SettingsAction.loadFailure: _onLoadFailure,
      SettingsAction.showLoading: _onShowLoading,
      SettingsAction.refreshUserInfo: _onRefreshUserInfo,
      SettingsAction.updateCurrentIndexLan: _onUpdateCurrentIndexLan,
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

SettingsState _onRefreshUserInfo(SettingsState state, Action action) {
  final SettingsState newState = state.clone()..userInfo = action.payload;
  return newState;
}

SettingsState _onUpdateCurrentIndexLan(SettingsState state, Action action) {
  final SettingsState newState = state.clone()
    ..currentIndexLan = action.payload;
  return newState;
}
