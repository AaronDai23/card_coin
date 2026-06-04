
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/common_info_bean.dart';
import 'action.dart';
import 'state.dart';

Reducer<CommonInfoState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CommonInfoState>>{
      CommonInfoAction.loadSuccess: _onLoadSuccess,
      CommonInfoAction.loadFailure: _onLoadFailure,
      CommonInfoAction.showLoading: _onShowLoading,
    },
  );
}

CommonInfoState _onLoadSuccess(CommonInfoState state, Action action) {
  CommonInfo commonInfo =  action.payload;
  final CommonInfoState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..docTitle = commonInfo.docName
    ..docContent = commonInfo.docContext;
  return newState;
}

CommonInfoState _onLoadFailure(CommonInfoState state, Action action) {
  final CommonInfoState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

CommonInfoState _onShowLoading(CommonInfoState state, Action action) {
  final CommonInfoState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}
