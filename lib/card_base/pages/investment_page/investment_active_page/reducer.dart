import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentActiveState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentActiveState>>{
      InvestmentActiveAction.action: _onAction,
      InvestmentActiveAction.showLoading: _onShowLoading,
      InvestmentActiveAction.loadSuccess: _onLoadSuccess,
      InvestmentActiveAction.loadFailed: _onLoadFailed,
      InvestmentActiveAction.updateActivitedStatus: _onUpdateActivtStatus,
    },
  );
}

InvestmentActiveState _onAction(InvestmentActiveState state, Action action) {
  final InvestmentActiveState newState = state.clone();
  return newState;
}

InvestmentActiveState _onShowLoading(
    InvestmentActiveState state, Action action) {
  final InvestmentActiveState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

InvestmentActiveState _onLoadSuccess(
    InvestmentActiveState state, Action action) {
  final InvestmentActiveState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..defaultCurrencyList = action.payload;
  return newState;
}

InvestmentActiveState _onUpdateActivtStatus(
    InvestmentActiveState state, Action action) {
  final InvestmentActiveState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..activeStatus = action.payload;
  return newState;
}

InvestmentActiveState _onLoadFailed(
    InvestmentActiveState state, Action action) {
  final InvestmentActiveState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
