import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WriteCardState>? buildReducer() {
  return asReducer(
    <Object, Reducer<WriteCardState>>{
      WriteCardAction.updateData: _onUpdateData,
      WriteCardAction.loadSuccess: _onLoadSuccess,
      WriteCardAction.showLoading: _onShowLoading,
      WriteCardAction.loadFailed: _onLoadFailed,
    },
  );
}

WriteCardState _onUpdateData(WriteCardState state, Action action) {
  final WriteCardState newState = state.clone()..readData = action.payload;
  return newState;
}

WriteCardState _onShowLoading(WriteCardState state, Action action) {
  final WriteCardState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

WriteCardState _onLoadSuccess(WriteCardState state, Action action) {
  final WriteCardState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..currencyInfo = action.payload;
  return newState;
}

WriteCardState _onLoadFailed(WriteCardState state, Action action) {
  final WriteCardState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
