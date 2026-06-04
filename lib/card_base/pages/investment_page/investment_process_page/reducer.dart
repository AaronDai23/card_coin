import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentProcessState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentProcessState>>{
      InvestmentProcessAction.action: _onAction,
      InvestmentProcessAction.updateView: _onLoadSuccess,
      InvestmentProcessAction.showLoading: _onShowLoading,
    },
  );
}

InvestmentProcessState _onLoadSuccess(
    InvestmentProcessState state, Action action) {
  List<FlowProgressNewInfo> steps = action.payload;
  final InvestmentProcessState newState = state.clone()
    ..steps = steps
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvestmentProcessState _onAction(InvestmentProcessState state, Action action) {
  final InvestmentProcessState newState = state.clone();
  return newState;
}

InvestmentProcessState _onShowLoading(
    InvestmentProcessState state, Action action) {
  final InvestmentProcessState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
