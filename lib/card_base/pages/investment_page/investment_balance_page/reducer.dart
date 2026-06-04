import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentBalanceState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentBalanceState>>{
      InvestmentBalanceAction.action: _onAction,
      InvestmentBalanceAction.loadSuccess: _onLoadSuccess,
      InvestmentBalanceAction.loadFailure: _onLoadFailure,
      InvestmentBalanceAction.showLoading: _onShowLoading
    },
  );
}

InvestmentBalanceState _onAction(InvestmentBalanceState state, Action action) {
  final InvestmentBalanceState newState = state.clone();
  return newState;
}

InvestmentBalanceState _onLoadSuccess(
    InvestmentBalanceState state, Action action) {
  List<InvestmentBalance> investmentInfos = action.payload;
  final InvestmentBalanceState newState = state.clone()
    ..list = investmentInfos
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentBalanceState _onLoadFailure(
    InvestmentBalanceState state, Action action) {
  final InvestmentBalanceState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentBalanceState _onShowLoading(
    InvestmentBalanceState state, Action action) {
  final InvestmentBalanceState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
