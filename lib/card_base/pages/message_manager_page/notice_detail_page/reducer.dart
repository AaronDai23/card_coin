
import 'package:fish_redux/fish_redux.dart';

import '../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<NoticeDetailState>? buildReducer() {
  return asReducer(
    <Object, Reducer<NoticeDetailState>>{
      NoticeDetailAction.loadSuccess: _onLoadSuccess,
      NoticeDetailAction.loadFailure: _onLoadFailure,
      NoticeDetailAction.showLoading: _onShowLoading,
    },
  );
}

NoticeDetailState _onLoadSuccess(NoticeDetailState state, Action action) {
  final NoticeDetailState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..noticeDetail = action.payload;
  return newState;
}

NoticeDetailState _onLoadFailure(NoticeDetailState state, Action action) {
  final NoticeDetailState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

NoticeDetailState _onShowLoading(NoticeDetailState state, Action action) {
  final NoticeDetailState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
