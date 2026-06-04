import 'package:card_coin/bean/coin_message_item.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CoinMessageListState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CoinMessageListState>>{
      CoinMessageListAction.action: _onAction,
      CoinMessageListAction.loadSuccess: _onLoadSuccess,
      CoinMessageListAction.loadFailure: _onLoadFailure,
      CoinMessageListAction.showLoading: _onShowLoading,
    },
  );
}

CoinMessageListState _onAction(CoinMessageListState state, Action action) {
  final CoinMessageListState newState = state.clone();
  return newState;
}

CoinMessageListState _onLoadSuccess(CoinMessageListState state, Action action) {
  List<CoinMessageItem> items = action.payload['summary'].items ?? [];
  print("CoinMessageListState6");
  bool isMore = action.payload['isMore'];
  List<CoinMessageItem> list;
  if (isMore) {
    list = state.items.toList();
    list.addAll(items);
  } else {
    list = items;
  }
  print("CoinMessageListState7:list:${list.length}");
  final CoinMessageListState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..items = list;
  return newState;
}

CoinMessageListState _onLoadFailure(CoinMessageListState state, Action action) {
  final CoinMessageListState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

CoinMessageListState _onShowLoading(CoinMessageListState state, Action action) {
  final CoinMessageListState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
