import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BindEmailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<BindEmailState>>{
      BindEmailAction.loadFailed: _onLoadFailed,
      BindEmailAction.loadSuccess: _onLoadSuccess,
    },
  );
}

BindEmailState _onLoadFailed(BindEmailState state, Action action) {
  final BindEmailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

BindEmailState _onLoadSuccess(BindEmailState state, Action action) {
  final BindEmailState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..systemConfig = action.payload;
  return newState;
}
