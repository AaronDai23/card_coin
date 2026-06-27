import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/more_menu_info.dart';
import 'action.dart';
import 'state.dart';

Reducer<MainState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MainState>>{
      MainAction.updateUserInfo: _onUpdateUserInfo,
      MainAction.loadSuccess: _onLoadSuccess,
      MainAction.loadFailure: _onLoadFailure,
      MainAction.showLoading: _onShowLoading,
      MainAction.applyJump: _onJump,
      MainAction.updateCardId: _onUpdateCardId,
      MainAction.updateCategoryList: _onUpdateCategoryList,
    },
  );
}

MainState _onUpdateUserInfo(MainState state, Action action) {
  final MainState newState = state.clone()..userInfo = action.payload;
  return newState;
}

MainState _onLoadSuccess(MainState state, Action action) {
  final MainState newState = state.clone()
    ..tabList = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MainState _onLoadFailure(MainState state, Action action) {
  final MainState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MainState _onShowLoading(MainState state, Action action) {
  final MainState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

MainState _onUpdateCardId(MainState state, Action action) {
  final MainState newState = state.clone()
    ..currentCardUid = action.payload?.toString() ?? '';
  return newState;
}

MainState _onJump(MainState state, Action action) {
  final MainState newState = state.clone()..currentIndex = action.payload;
  return newState;
}

MainState _onUpdateCategoryList(MainState state, Action action) {
  MoreMenuInfo menuInfo = action.payload;
  final MainState newState = state.clone()..menuInfo = menuInfo;
  return newState;
}
