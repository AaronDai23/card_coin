import 'package:card_coin/card_base/bean/investment_single_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentSingleDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentSingleDetailState>>{
      InvestmentSingleDetailAction.action: _onAction,
      InvestmentSingleDetailAction.loadSuccess: _onLoadSuccess,
      InvestmentSingleDetailAction.loadFailure: _onLoadFailure,
      InvestmentSingleDetailAction.showLoading: _onShowLoading
    },
  );
}

InvestmentSingleDetailState _onAction(
    InvestmentSingleDetailState state, Action action) {
  final InvestmentSingleDetailState newState = state.clone();
  return newState;
}

InvestmentSingleDetailState _onLoadSuccess(
    InvestmentSingleDetailState state, Action action) {
  InvestmentSingleInfo investment = action.payload;

  final InvestmentSingleDetailState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..investmentSingleInfo = investment;
  return newState;
}

InvestmentSingleDetailState _onLoadFailure(
    InvestmentSingleDetailState state, Action action) {
  final InvestmentSingleDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentSingleDetailState _onShowLoading(
    InvestmentSingleDetailState state, Action action) {
  final InvestmentSingleDetailState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
