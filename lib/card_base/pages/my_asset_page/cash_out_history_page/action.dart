import 'dart:async';

import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum CashOutHistoryAction {
  loadHistory,
  loadHistorySuccess,
  loadMore,
  updateLoading,
}

class CashOutHistoryActionCreator {
  static Action onLoadHistory({Completer<void>? completer}) =>
      Action(CashOutHistoryAction.loadHistory, payload: completer);

  static Action onLoadHistorySuccess(
          List<CashOutHistoryItem> rows, int total, int page, bool hasMore) =>
      Action(CashOutHistoryAction.loadHistorySuccess, payload: {
        'rows': rows,
        'total': total,
        'page': page,
        'hasMore': hasMore
      });

  static Action onLoadMore() => const Action(CashOutHistoryAction.loadMore);

  static Action onUpdateLoading(bool loading) =>
      Action(CashOutHistoryAction.updateLoading, payload: loading);
}
