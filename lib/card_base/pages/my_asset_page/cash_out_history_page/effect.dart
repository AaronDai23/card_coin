import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

const int _pageSize = 20;

Effect<CashOutHistoryState>? buildEffect() {
  return combineEffects(<Object, Effect<CashOutHistoryState>>{
    Lifecycle.initState: _onInit,
    CashOutHistoryAction.loadHistory: _onLoadHistory,
    CashOutHistoryAction.loadMore: _onLoadMore,
  });
}

void _onInit(Action action, Context<CashOutHistoryState> ctx) {
  ctx.dispatch(CashOutHistoryActionCreator.onLoadHistory());
}

Future<void> _onLoadHistory(
    Action action, Context<CashOutHistoryState> ctx) async {
  ctx.dispatch(CashOutHistoryActionCreator.onUpdateLoading(true));

  final result = await HttpManager.getInstance().get(
    NetworkAddress.cashOutHistory,
    queryParameters: {
      'uid': ctx.state.uid,
      'page': 1,
      'pageSize': _pageSize,
    },
  );

  if (result.isSuccess && result.data is Map) {
    final data = result.data as Map<String, dynamic>;
    final total = int.tryParse(data['total']?.toString() ?? '0') ?? 0;
    final rawRows = data['rows'];
    final rows = rawRows is List
        ? rawRows
            .map((e) => CashOutHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CashOutHistoryItem>[];
    ctx.dispatch(CashOutHistoryActionCreator.onLoadHistorySuccess(
        rows, total, 1, rows.length < _pageSize));
  } else {
    ctx.dispatch(CashOutHistoryActionCreator.onUpdateLoading(false));
    showToast(result.message);
  }
}

Future<void> _onLoadMore(
    Action action, Context<CashOutHistoryState> ctx) async {
  final state = ctx.state;
  if (state.isLoading || !state.hasMore) return;

  final nextPage = state.page + 1;
  ctx.dispatch(CashOutHistoryActionCreator.onUpdateLoading(true));

  final result = await HttpManager.getInstance().get(
    NetworkAddress.cashOutHistory,
    queryParameters: {
      'uid': state.uid,
      'page': nextPage,
      'pageSize': _pageSize,
    },
  );

  if (result.isSuccess && result.data is Map) {
    final data = result.data as Map<String, dynamic>;
    final total = int.tryParse(data['total']?.toString() ?? '0') ?? 0;
    final rawRows = data['rows'];
    final rows = rawRows is List
        ? rawRows
            .map((e) => CashOutHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CashOutHistoryItem>[];
    ctx.dispatch(CashOutHistoryActionCreator.onLoadHistorySuccess(
        rows, total, nextPage, rows.length < _pageSize));
  } else {
    ctx.dispatch(CashOutHistoryActionCreator.onUpdateLoading(false));
    showToast(result.message);
  }
}
