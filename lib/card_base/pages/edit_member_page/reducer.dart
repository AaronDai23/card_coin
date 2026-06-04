
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<EditMemberState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EditMemberState>>{
      EditMemberAction.loadSuccess: _onLoadSuccess,
      EditMemberAction.loadFailure: _onLoadFailure,
      EditMemberAction.showLoading: _onShowLoading,
    },
  );
}

EditMemberState _onLoadSuccess(EditMemberState state, Action action) {
  final EditMemberState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..isBind = action.payload;
  return newState;
}

EditMemberState _onLoadFailure(EditMemberState state, Action action) {
  final EditMemberState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}
EditMemberState _onShowLoading(EditMemberState state, Action action) {
  final EditMemberState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
