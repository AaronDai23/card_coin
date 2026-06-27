import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ConvertHistoryState>? buildReducer() {
  return asReducer(<Object, Reducer<ConvertHistoryState>>{
    ConvertHistoryAction.updateLoading: _onUpdateLoading,
    ConvertHistoryAction.loadHistorySuccess: _onLoadHistorySuccess,
  });
}

ConvertHistoryState _onUpdateLoading(ConvertHistoryState state, Action action) {
  final next = state.clone();
  next.isLoading = action.payload as bool;
  return next;
}

ConvertHistoryState _onLoadHistorySuccess(
    ConvertHistoryState state, Action action) {
  final payload = action.payload as Map<String, dynamic>;
  final newRows = payload['rows'] as List<ConvertHistoryItem>;
  final int page = payload['page'] as int;
  final next = state.clone();
  next.total = payload['total'] as int;
  next.page = page;
  next.hasMore = payload['hasMore'] as bool;
  next.isLoading = false;

  if (page == 1) {
    next.rows = newRows;
  } else {
    next.rows = [...state.rows, ...newRows];
  }
  return next;
}
