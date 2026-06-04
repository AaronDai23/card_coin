
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<ScanLoginState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ScanLoginState>>{
      ScanLoginAction.loadSuccess: _onLoadSuccess,
      ScanLoginAction.loadFailure: _onLoadFailure,
      ScanLoginAction.showLoading: _onShowLoading,
      ScanLoginAction.updateScanning: _onUpdateScanning,
    },
  );
}

ScanLoginState _onLoadSuccess(ScanLoginState state, Action action) {
  final ScanLoginState newState = state.clone()
    ..banners = action.payload['banners']
    ..buttons = action.payload['buttons']
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

ScanLoginState _onLoadFailure(ScanLoginState state, Action action) {
  final ScanLoginState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

ScanLoginState _onShowLoading(ScanLoginState state, Action action) {
  final ScanLoginState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

ScanLoginState _onUpdateScanning(ScanLoginState state, Action action) {
  final ScanLoginState newState = state.clone()..isScanning = action.payload;
  return newState;
}

