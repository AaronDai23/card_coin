import 'package:card_coin/card_base/bean/points_history_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MemberPointsState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MemberPointsState>>{
      MemberPointsAction.action: _onAction,
      MemberPointsAction.loadSuccess: _onLoadSuccess,
      MemberPointsAction.loadFailed: _onLoadFailed,
      MemberPointsAction.showLoading: _onShowLoading,
    },
  );
}

MemberPointsState _onAction(MemberPointsState state, Action action) {
  final MemberPointsState newState = state.clone();
  return newState;
}

MemberPointsState _onLoadSuccess(MemberPointsState state, Action action) {
  PointsHistoryInfo listInfo = action.payload['listInfo'];
  bool isMore = action.payload['isMore'];
  List<PointsHistory> list;
  if (isMore) {
    list = state.list.toList();
    list.addAll(listInfo.rows ?? []);
  } else {
    list = listInfo.rows ?? [];
  }
  final MemberPointsState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..list = list;

  return newState;
}

MemberPointsState _onLoadFailed(MemberPointsState state, Action action) {
  final MemberPointsState newState = state.clone()
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

MemberPointsState _onShowLoading(MemberPointsState state, Action action) {
  final MemberPointsState newState = state.clone();
  return newState..loadStatus = LoadType.loading;
}
