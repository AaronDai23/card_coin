import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CashOutHistoryState>? buildReducer() {
  return asReducer(<Object, Reducer<CashOutHistoryState>>{
    CashOutHistoryAction.updateLoading: _onUpdateLoading,
    CashOutHistoryAction.loadHistorySuccess: _onLoadHistorySuccess,
  });
}

CashOutHistoryState _onUpdateLoading(CashOutHistoryState state, Action action) {
  final next = state.clone();
  next.isLoading = action.payload as bool;
  return next;
}

CashOutHistoryState _onLoadHistorySuccess(
    CashOutHistoryState state, Action action) {
  final payload = action.payload as Map<String, dynamic>;
  final newRows = payload['rows'] as List<CashOutHistoryItem>;
  final int page = payload['page'] as int;
  final next = state.clone();
  next.total = payload['total'] as int;
  next.page = page;
  next.hasMore = payload['hasMore'] as bool;
  next.isLoading = false;
  // First page: replace; subsequent pages: append
  if (page == 1) {
    next.rows = newRows;
  } else {
    next.rows = [...state.rows, ...newRows];
  }
  return next;
}
