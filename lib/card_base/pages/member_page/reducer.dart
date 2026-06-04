
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/member_level_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<MemberState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MemberState>>{
      // MemberAction.action: _onAction,
      MemberAction.loadSuccess: _onLoadSuccess,
      MemberAction.loadFailure: _onLoadFailure,
      MemberAction.showLoading: _onShowLoading,
      MemberAction.updateIndex: _onUpdateIndex,
    },
  );
}

MemberState _onUpdateIndex(MemberState state, Action action) {
  final MemberState newState = state.clone()..index = action.payload;
  return newState;
}

MemberState _onLoadSuccess(MemberState state, Action action) {
  MemberLevelInfo memberLevelInfo = action.payload['memberLevelInfo'];
  CustomerLevelInfo customerLevelInfo = action.payload['customerInfo'];

  final MemberState newState = state.clone()
    ..currentLevel = memberLevelInfo.currentLevel
    ..customerLevels = memberLevelInfo.customerLevels
    ..customerLevelInfo = customerLevelInfo
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MemberState _onLoadFailure(MemberState state, Action action) {
  final MemberState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MemberState _onShowLoading(MemberState state, Action action) {
  final MemberState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
