import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<MainState>? buildReducer() {
  return asReducer(
    <Object, Reducer<MainState>>{
      MainAction.updateCardList: _onUpdateCardList,
      MainAction.updateSupportBiometric: _onUpdateSupportBiometric,
      MainAction.showLoading: _onShowLoading,
      MainAction.loadSuccess: _onLoadSuccess,
      MainAction.loadFailed: _onLoadFailed,
    },
  );
}

MainState _onUpdateCardList(MainState state, Action action) {
  final MainState newState = state.clone()
    // ..cardInfoList = action.payload
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

MainState _onShowLoading(MainState state, Action action) {
  final MainState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

MainState _onLoadSuccess(MainState state, Action action) {
  final MainState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..defaultCurrencyList = action.payload;
  return newState;
}

MainState _onLoadFailed(MainState state, Action action) {
  final MainState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

MainState _onUpdateSupportBiometric(MainState state, Action action) {
  final MainState newState = state.clone()..supportBiometric = action.payload;
  return newState;
}
