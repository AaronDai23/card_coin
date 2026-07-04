import 'dart:async';

import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum ConvertHistoryAction {
  loadHistory,
  loadHistorySuccess,
  loadMore,
  updateLoading,
}

class ConvertHistoryActionCreator {
  static Action onLoadHistory({Completer<void>? completer}) =>
      Action(ConvertHistoryAction.loadHistory, payload: completer);

  static Action onLoadHistorySuccess(
          List<ConvertHistoryItem> rows, int total, int page, bool hasMore) =>
      Action(ConvertHistoryAction.loadHistorySuccess, payload: {
        'rows': rows,
        'total': total,
        'page': page,
        'hasMore': hasMore,
      });

  static Action onLoadMore() => const Action(ConvertHistoryAction.loadMore);

  static Action onUpdateLoading(bool loading) =>
      Action(ConvertHistoryAction.updateLoading, payload: loading);
}
