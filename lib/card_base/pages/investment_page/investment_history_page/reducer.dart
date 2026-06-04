import 'package:card_coin/card_base/bean/investment_history_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentHistoryState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentHistoryState>>{
      InvestmentHistoryAction.action: _onAction,
      InvestmentHistoryAction.loadSuccess: _onLoadSuccess,
      InvestmentHistoryAction.loadFailure: _onLoadFailure,
      InvestmentHistoryAction.showLoading: _onShowLoading
    },
  );
}

InvestmentHistoryState _onAction(InvestmentHistoryState state, Action action) {
  final InvestmentHistoryState newState = state.clone();
  return newState;
}

InvestmentHistoryState _onLoadSuccess(
    InvestmentHistoryState state, Action action) {
  List<InvestmentHistoryInfo> investmentInfos = action.payload;
  final InvestmentHistoryState newState = state.clone()
    ..list = investmentInfos
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentHistoryState _onLoadFailure(
    InvestmentHistoryState state, Action action) {
  final InvestmentHistoryState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentHistoryState _onShowLoading(
    InvestmentHistoryState state, Action action) {
  final InvestmentHistoryState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
