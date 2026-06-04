import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AssetSettingsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AssetSettingsState>>{
      // AssetSettingsAction.action: _onAction,
      AssetSettingsAction.loadSuccess: _onLoadSuccess,
      AssetSettingsAction.loadFailure: _onLoadFailure,
      AssetSettingsAction.showLoading: _onShowLoading,
      AssetSettingsAction.updateList: _onUpdateList,
    },
  );
}

AssetSettingsState _onUpdateList(AssetSettingsState state, Action action) {
  final AssetSettingsState newState = state.clone()..list = action.payload;
  return newState;
}

AssetSettingsState _onLoadSuccess(AssetSettingsState state, Action action) {
  final AssetSettingsState newState = state.clone()
    ..list = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

AssetSettingsState _onLoadFailure(AssetSettingsState state, Action action) {
  final AssetSettingsState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

AssetSettingsState _onShowLoading(AssetSettingsState state, Action action) {
  final AssetSettingsState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
