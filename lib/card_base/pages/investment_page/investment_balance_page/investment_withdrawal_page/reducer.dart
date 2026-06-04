import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentWithdrawalState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentWithdrawalState>>{
      InvestmentWithdrawalAction.action: _onAction,
      InvestmentWithdrawalAction.loadSuccess: _onLoadSuccess,
      InvestmentWithdrawalAction.loadFailure: _onLoadFailure,
      InvestmentWithdrawalAction.showLoading: _onShowLoading,
      InvestmentWithdrawalAction.update: _onUpdateAction,
    },
  );
}

InvestmentWithdrawalState _onAction(
    InvestmentWithdrawalState state, Action action) {
  final InvestmentWithdrawalState newState = state.clone();
  return newState;
}

InvestmentWithdrawalState _onUpdateAction(
    InvestmentWithdrawalState state, Action action) {
  final InvestmentWithdrawalState newState = state.clone();
  return newState;
}

InvestmentWithdrawalState _onLoadSuccess(
    InvestmentWithdrawalState state, Action action) {
  InvestmentBalance investmentInfo = action.payload;
  final InvestmentWithdrawalState newState = state.clone()
    ..detail = investmentInfo
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentWithdrawalState _onLoadFailure(
    InvestmentWithdrawalState state, Action action) {
  final InvestmentWithdrawalState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentWithdrawalState _onShowLoading(
    InvestmentWithdrawalState state, Action action) {
  final InvestmentWithdrawalState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
