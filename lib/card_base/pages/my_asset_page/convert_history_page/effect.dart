import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';

import 'action.dart';
import 'state.dart';

const int _pageSize = 20;

Effect<ConvertHistoryState>? buildEffect() {
  return combineEffects(<Object, Effect<ConvertHistoryState>>{
    Lifecycle.initState: _onInit,
    ConvertHistoryAction.loadHistory: _onLoadHistory,
    ConvertHistoryAction.loadMore: _onLoadMore,
  });
}

void _onInit(Action action, Context<ConvertHistoryState> ctx) {
  ctx.dispatch(ConvertHistoryActionCreator.onLoadHistory());
}

Future<void> _onLoadHistory(
    Action action, Context<ConvertHistoryState> ctx) async {
  ctx.dispatch(ConvertHistoryActionCreator.onUpdateLoading(true));

  final result = await HttpManager.getInstance().get(
    NetworkAddress.assetExchangeHistory,
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
            .map((e) => ConvertHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <ConvertHistoryItem>[];
    final loaded = rows.length;
    ctx.dispatch(ConvertHistoryActionCreator.onLoadHistorySuccess(
        rows, total, 1, loaded < total));
  } else {
    ctx.dispatch(ConvertHistoryActionCreator.onUpdateLoading(false));
    showToast(result.message);
  }
}

Future<void> _onLoadMore(
    Action action, Context<ConvertHistoryState> ctx) async {
  final state = ctx.state;
  if (state.isLoading || !state.hasMore) return;

  final nextPage = state.page + 1;
  ctx.dispatch(ConvertHistoryActionCreator.onUpdateLoading(true));

  final result = await HttpManager.getInstance().get(
    NetworkAddress.assetExchangeHistory,
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
            .map((e) => ConvertHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList()
        : <ConvertHistoryItem>[];
    final loaded = (nextPage - 1) * _pageSize + rows.length;
    ctx.dispatch(ConvertHistoryActionCreator.onLoadHistorySuccess(
        rows, total, nextPage, loaded < total));
  } else {
    ctx.dispatch(ConvertHistoryActionCreator.onUpdateLoading(false));
    showToast(result.message);
  }
}
