import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HdRechargeState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HdRechargeState>>{
      HdRechargeAction.action: _onAction,
      HdRechargeAction.loadSuccess: _onLoadSuccess,
      HdRechargeAction.showLoading: _onShowLoading,
      HdRechargeAction.loadFailed: _onLoadFailed,
    },
  );
}

HdRechargeState _onAction(HdRechargeState state, Action action) {
  final HdRechargeState newState = state.clone();
  return newState;
}

HdRechargeState _onShowLoading(HdRechargeState state, Action action) {
  final HdRechargeState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

HdRechargeState _onLoadSuccess(HdRechargeState state, Action action) {
  CurrencyInfo currency = action.payload;
  print("HdRechargeState_onLoadSuccess0:${currency.currencyData.symbol}");
  final HdRechargeState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..currencyInfo = action.payload;
  return newState;
}

HdRechargeState _onLoadFailed(HdRechargeState state, Action action) {
  final HdRechargeState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
