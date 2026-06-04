import 'package:card_coin/card_base/bean/asset_summary_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyAssetState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MyAssetState>>{
      MyAssetAction.loadSuccess: _onLoadSuccess,
      MyAssetAction.loadFailure: _onLoadFailure,
      MyAssetAction.showLoading: _onShowLoading,
    },
  );
}

MyAssetState _onLoadSuccess(MyAssetState state, Action action) {
  AssetSummaryInfo info = action.payload;
  final MyAssetState newState = state.clone()
    ..assetSummaryInfo = info
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MyAssetState _onLoadFailure(MyAssetState state, Action action) {
  final MyAssetState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MyAssetState _onShowLoading(MyAssetState state, Action action) {
  final MyAssetState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}
