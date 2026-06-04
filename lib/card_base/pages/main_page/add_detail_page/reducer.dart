
import 'package:fish_redux/fish_redux.dart';

import '../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<AddDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AddDetailState>>{
      // AddDetailAction.action: _onAction,
      AddDetailAction.loadSuccess: _onLoadSuccess,
      AddDetailAction.loadFailure: _onLoadFailure,
      AddDetailAction.showLoading: _onShowLoading,
    },
  );
}


AddDetailState _onLoadSuccess(AddDetailState state, Action action) {
  final AddDetailState newState = state.clone()
    ..typeDetail = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

AddDetailState _onLoadFailure(AddDetailState state, Action action) {
  final AddDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

AddDetailState _onShowLoading(AddDetailState state, Action action) {
  final AddDetailState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
