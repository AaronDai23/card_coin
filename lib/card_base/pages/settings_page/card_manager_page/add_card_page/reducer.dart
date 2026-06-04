
import 'package:fish_redux/fish_redux.dart';

import '../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<AddCardState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AddCardState>>{
      AddCardAction.loadSuccess: _onLoadSuccess,
      AddCardAction.loadFailure: _onLoadFailure,
      AddCardAction.showLoading: _onShowLoading,
    },
  );
}


AddCardState _onLoadSuccess(AddCardState state, Action action) {
  final AddCardState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..isBindCard = action.payload;
  return newState;
}

AddCardState _onLoadFailure(AddCardState state, Action action) {
  final AddCardState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

AddCardState _onShowLoading(AddCardState state, Action action) {
  final AddCardState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
