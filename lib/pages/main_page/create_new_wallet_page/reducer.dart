import 'package:fish_redux/fish_redux.dart';

import '../../../bean/card_info_bean.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<CreateNewWalletState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CreateNewWalletState>>{
      CreateNewWalletAction.action: _onAction,
      CreateNewWalletAction.loadSuccess: _onLoadSuccess,
      CreateNewWalletAction.loadFailure: _onLoadFailure,
    },
  );
}

CreateNewWalletState _onAction(CreateNewWalletState state, Action action) {
  final CreateNewWalletState newState = state.clone();
  return newState;
}


CreateNewWalletState _onLoadSuccess(CreateNewWalletState state, Action action) {
  CardDetail? cardDetail = action.payload;
  final CreateNewWalletState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..cardDetail = cardDetail;
  return newState;
}

CreateNewWalletState _onLoadFailure(CreateNewWalletState state, Action action) {
  final CreateNewWalletState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
