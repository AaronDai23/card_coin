import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentState>>{
      InvestmentAction.action: _onAction,
      InvestmentAction.loadSuccess: _onLoadSuccess,
      InvestmentAction.loadFailure: _onLoadFailure,
      InvestmentAction.showLoading: _onShowLoading
    },
  );
}

InvestmentState _onAction(InvestmentState state, Action action) {
  final InvestmentState newState = state.clone();
  return newState;
}

InvestmentState _onLoadSuccess(InvestmentState state, Action action) {
  List<InvestmentInfo> investmentInfos = action.payload;
  final InvestmentState newState = state.clone()
    ..list = investmentInfos
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentState _onLoadFailure(InvestmentState state, Action action) {
  final InvestmentState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InvestmentState _onShowLoading(InvestmentState state, Action action) {
  final InvestmentState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
