import 'package:card_coin/pages/main_page/lightning_net_detail_page/light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WithdrawLightningState>? buildReducer() {
  return asReducer(
    <Object, Reducer<WithdrawLightningState>>{
      WithdrawLightningAction.action: _onAction,
      WithdrawLightningAction.loadSuccess: _onLoadSuccess,
      WithdrawLightningAction.loadFailed: _onLoadFailed,
      // WithdrawLightningAction.unitChanged: _onUnitChanged,
      WithdrawLightningAction.update: _onUpdateAction,
    },
  );
}

WithdrawLightningState _onAction(WithdrawLightningState state, Action action) {
  final WithdrawLightningState newState = state.clone();
  return newState;
}

WithdrawLightningState _onLoadSuccess(WithdrawLightningState state, Action action) {
  List<UnitInfo> list = action.payload;
  UnitInfo selectedUnit = list.first;
  UnitInfo usdtUnit = list.firstWhere((element) => element.symbol.toUpperCase() == "USDT");
  final WithdrawLightningState newState = state.clone()
    ..unitInfoList = list
    ..selectedUnit = selectedUnit
    ..usdtUnit = usdtUnit
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

WithdrawLightningState _onLoadFailed(WithdrawLightningState state, Action action) {
  final WithdrawLightningState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

// WithdrawLightningState _onUnitChanged(WithdrawLightningState state, Action action) {
//   final WithdrawLightningState newState = state.clone()
//     ..selectedUnit = action.payload;
//   return newState;
// }

WithdrawLightningState _onUpdateAction(WithdrawLightningState state, Action action) {
  final WithdrawLightningState newState = state.clone();
  return newState;
}