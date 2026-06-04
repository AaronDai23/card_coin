import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<ScanWalletState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ScanWalletState>>{
      ScanWalletAction.action: _onAction,
      ScanWalletAction.showLoading: _onShowLoading,
      ScanWalletAction.loadSuccess: _onLoadSuccess,
      ScanWalletAction.loadFailed: _onLoadFailed,
    },
  );
}

ScanWalletState _onAction(ScanWalletState state, Action action) {
  final ScanWalletState newState = state.clone();
  return newState;
}

ScanWalletState _onShowLoading(ScanWalletState state, Action action) {
  final ScanWalletState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

ScanWalletState _onLoadSuccess(ScanWalletState state, Action action) {
  final ScanWalletState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..defaultCurrencyList = action.payload;
  return newState;
}

ScanWalletState _onLoadFailed(ScanWalletState state, Action action) {
  final ScanWalletState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
