import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentHandleState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentHandleState>>{
      InvestmentHandleAction.action: _onAction,
      InvestmentHandleAction.loadSuccess: _onLoadSuccess,
      InvestmentHandleAction.loadFailure: _onLoadFailure,
      InvestmentHandleAction.showLoading: _onShowLoading,
      InvestmentHandleAction.ploadSuccess: _onProLoadSuccess,
      InvestmentHandleAction.update: _onUpdateAction,
    },
  );
}

InvestmentHandleState _onAction(InvestmentHandleState state, Action action) {
  final InvestmentHandleState newState = state.clone();
  return newState;
}

InvestmentHandleState _onUpdateAction(
    InvestmentHandleState state, Action action) {
  final InvestmentHandleState newState = state.clone();
  return newState;
}

InvestmentHandleState _onLoadSuccess(
    InvestmentHandleState state, Action action) {
  InvestmentInfo investmentInfo = action.payload;
  final InvestmentHandleState newState = state.clone()
    ..investDetail = investmentInfo
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentHandleState _onLoadFailure(
    InvestmentHandleState state, Action action) {
  final InvestmentHandleState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentHandleState _onShowLoading(
    InvestmentHandleState state, Action action) {
  final InvestmentHandleState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

InvestmentHandleState _onProLoadSuccess(
    InvestmentHandleState state, Action action) {
  print("_onProLoadSuccess:${state.coinInfo?.toJson()}");

  final InvestmentHandleState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..coinInfo = state.coinInfo
    ..cycleInfo = state.cycleInfo;
  print("_onProLoadSuccess-new:${newState.coinInfo?.toJson()}");
  return newState;
}
