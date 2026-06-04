import 'package:fish_redux/fish_redux.dart';

import '../../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<MyCardState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MyCardState>>{
      MyCardAction.loadSuccess: _onLoadSuccess,
      MyCardAction.loadFailure: _onLoadFailure,
      MyCardAction.showLoading: _onShowLoading,
      MyCardAction.clearCardDetail: _onClearCardDetail,
      MyCardAction.updateViewAfterUpdateCurrentNum:
          _onUpdateViewAfterUpdateCurrentNum,
      MyCardAction.kLine: _onUpdateKline,
      MyCardAction.cryptoTotalPrice: _onCryptoTotalPrice,
      MyCardAction.updateFiat: _onUpdateFiat
    },
  );
}

MyCardState _onLoadSuccess(MyCardState state, Action action) {
  final dynamic nextCardDetail = action.payload;
  final String? nextUid = nextCardDetail?.uid as String?;
  final String? currentUid = state.cardDetail?.uid;
  final bool shouldResetPrimaryVisible =
      state.loadStatus != LoadType.loadSuccess || nextUid != currentUid;
  final MyCardState newState = state.clone()
    ..cardDetail = action.payload
    ..hasReportedPrimaryContentVisible = shouldResetPrimaryVisible
        ? false
        : state.hasReportedPrimaryContentVisible
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MyCardState _onLoadFailure(MyCardState state, Action action) {
  final MyCardState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MyCardState _onShowLoading(MyCardState state, Action action) {
  final MyCardState newState = state.clone()
    ..hasReportedPrimaryContentVisible = false
    ..loadStatus = LoadType.loading;
  return newState;
}

MyCardState _onClearCardDetail(MyCardState state, Action action) {
  final MyCardState newState = state.clone()
    ..cardDetail = null
    ..hasReportedPrimaryContentVisible = false
    ..loadStatus = LoadType.loading;
  return newState;
}

MyCardState _onUpdateViewAfterUpdateCurrentNum(
    MyCardState state, Action action) {
  final MyCardState newState = state.clone()..valueArr = action.payload;
  return newState;
}

MyCardState _onUpdateKline(MyCardState state, Action action) {
  final MyCardState newState = state.clone()..lineDatas = action.payload;
  return newState;
}

MyCardState _onUpdateFiat(MyCardState state, Action action) {
  final MyCardState newState = state.clone()..currentFiat = action.payload;
  return newState;
}

MyCardState _onCryptoTotalPrice(MyCardState state, Action action) {
  final MyCardState newState = state.clone()..cryptoTotalPrice = action.payload;
  return newState;
}
