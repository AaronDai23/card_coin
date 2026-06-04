import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BiometricsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<BiometricsState>>{
      BiometricsAction.action: _onAction,
      BiometricsAction.showLoading: _onShowLoading,
      BiometricsAction.loadSuccess: _onLoadSuccess,
      BiometricsAction.loadFailed: _onLoadFailed,
    },
  );
}

BiometricsState _onAction(BiometricsState state, Action action) {
  final BiometricsState newState = state.clone();
  return newState;
}

BiometricsState _onShowLoading(BiometricsState state, Action action) {
  final BiometricsState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

BiometricsState _onLoadSuccess(BiometricsState state, Action action) {
  final BiometricsState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..isBiometricEnabled = action.payload;
  return newState;
}

BiometricsState _onLoadFailed(BiometricsState state, Action action) {
  final BiometricsState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
