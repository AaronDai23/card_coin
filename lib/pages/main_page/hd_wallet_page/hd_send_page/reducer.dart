import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HdSendState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HdSendState>>{
      HdSendAction.updateValid: _onUpdateValid,
      HdSendAction.updateNetworks: _onUpdateNetworks,
      HdSendAction.updateNetworkIndex: _onUpdateNetworkIndex,
      HdSendAction.loadSuccess: _onLoadSuccess,
      HdSendAction.showLoading: _onShowLoading,
      HdSendAction.loadFailed: _onLoadFailed,
    },
  );
}

HdSendState _onUpdateValid(HdSendState state, Action action) {
  final HdSendState newState = state.clone()..isValidate = action.payload;
  return newState;
}

HdSendState _onUpdateNetworks(HdSendState state, Action action) {
  List<NetworkItem> list = action.payload;
  final HdSendState newState = state.clone()
    ..networkIndex = list.length > 2 ? 1 : 0
    ..networkList = list;
  return newState;
}

HdSendState _onUpdateNetworkIndex(HdSendState state, Action action) {
  final HdSendState newState = state.clone()..networkIndex = action.payload;
  return newState;
}

HdSendState _onShowLoading(HdSendState state, Action action) {
  final HdSendState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

HdSendState _onLoadSuccess(HdSendState state, Action action) {
  final HdSendState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..currencyInfo = action.payload
    ..feeAmount = 0
    ..isPasswordSet = state.isPasswordSet;
  return newState;
}

HdSendState _onLoadFailed(HdSendState state, Action action) {
  final HdSendState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
