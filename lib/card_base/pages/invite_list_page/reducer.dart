
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/invite_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<InviteListState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InviteListState>>{
      InviteListAction.loadSuccess: _onLoadSuccess,
      InviteListAction.loadFailure: _onLoadFailure,
      InviteListAction.showLoading: _onShowLoading
    },
  );
}

InviteListState _onLoadSuccess(InviteListState state, Action action) {
  InviteListInfo inviteListInfo = action.payload;
  final InviteListState newState = state.clone()
    ..list = inviteListInfo.rows??[]
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InviteListState _onLoadFailure(InviteListState state, Action action) {
  final InviteListState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

InviteListState _onShowLoading(InviteListState state, Action action) {
  final InviteListState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
