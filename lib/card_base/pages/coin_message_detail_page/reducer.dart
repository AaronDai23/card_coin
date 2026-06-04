import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CoinMessageDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CoinMessageDetailState>>{
      CoinMessageDetailAction.action: _onAction,
      CoinMessageDetailAction.loadSuccess: _onLoadSuccess,
      CoinMessageDetailAction.loadFailure: _onLoadFailure,
      CoinMessageDetailAction.showLoading: _onShowLoading,
    },
  );
}

CoinMessageDetailState _onAction(CoinMessageDetailState state, Action action) {
  final CoinMessageDetailState newState = state.clone();
  return newState;
}

CoinMessageDetailState _onLoadSuccess(
    CoinMessageDetailState state, Action action) {
  CoinMessageDetail detail = action.payload;
  final CoinMessageDetailState newState = state.clone()
    ..messageDetail = detail
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

CoinMessageDetailState _onLoadFailure(
    CoinMessageDetailState state, Action action) {
  final CoinMessageDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

CoinMessageDetailState _onShowLoading(
    CoinMessageDetailState state, Action action) {
  final CoinMessageDetailState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
