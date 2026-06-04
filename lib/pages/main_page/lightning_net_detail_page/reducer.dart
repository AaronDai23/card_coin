import 'package:card_coin/bean/light_spark_transactions.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LightningNetDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<LightningNetDetailState>>{
      LightningNetDetailAction.action: _onAction,
      LightningNetDetailAction.loadSuccess: _onLoadSuccess,
      LightningNetDetailAction.loadFailure: _onLoadFailure,
      LightningNetDetailAction.showLoading: _onShowLoading,
      LightningNetDetailAction.updatelightningNetValue:
          _onUpdatelightningNetValue,
      LightningNetDetailAction.updateTime: _onUpdateSecondValue
    },
  );
}

LightningNetDetailState _onAction(
    LightningNetDetailState state, Action action) {
  final LightningNetDetailState newState = state.clone();
  return newState;
}

LightningNetDetailState _onLoadSuccess(
    LightningNetDetailState state, Action action) {
  List<LightSparkTransactions> list = action.payload;
  final LightningNetDetailState newState = state.clone()
    ..historyTransactions = list
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

LightningNetDetailState _onLoadFailure(
    LightningNetDetailState state, Action action) {
  final LightningNetDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

LightningNetDetailState _onShowLoading(
    LightningNetDetailState state, Action action) {
  final LightningNetDetailState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

LightningNetDetailState _onUpdatelightningNetValue(
    LightningNetDetailState state, Action action) {
  final LightningNetDetailState newState = state.clone();
  newState.flashBalanceDetail = action.payload;
  return newState;
}

LightningNetDetailState _onUpdateSecondValue(
    LightningNetDetailState state, Action action) {
  final LightningNetDetailState newState = state.clone();
  newState.homeSeconds = action.payload;
  return newState;
}
