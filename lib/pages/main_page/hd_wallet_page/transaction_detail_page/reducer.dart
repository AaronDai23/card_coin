import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TransactionDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<TransactionDetailState>>{
      TransactionDetailAction.updateList: _onUpdateList,
      TransactionDetailAction.loadFailure: _onLoadFailure,
      TransactionDetailAction.loadSuccess: _onLoadSuccess,
    },
  );
}

TransactionDetailState _onUpdateList(
    TransactionDetailState state, Action action) {
  final TransactionDetailState newState = state.clone()
    ..historyTransactions = action.payload;
  return newState;
}

TransactionDetailState _onLoadFailure(
    TransactionDetailState state, Action action) {
  String errorMsg = action.payload;
  final TransactionDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = errorMsg;
  return newState;
}

TransactionDetailState _onLoadSuccess(
    TransactionDetailState state, Action action) {
  final TransactionDetailState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..historyTransactions = action.payload;
  return newState;
}
