import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LightNetInvoiceState>? buildReducer() {
  return asReducer(
    <Object, Reducer<LightNetInvoiceState>>{
      LightNetInvoiceAction.showLoading: _onShowLoading,
      LightNetInvoiceAction.loadSuccess: _onLoadSuccess,
      LightNetInvoiceAction.loadFailed: _onLoadFailed,
    },
  );
}

LightNetInvoiceState _onShowLoading(LightNetInvoiceState state, Action action) {
  final LightNetInvoiceState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

LightNetInvoiceState _onLoadSuccess(LightNetInvoiceState state, Action action) {
  final LightNetInvoiceState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..invoiceInfo = action.payload;
  return newState;
}

LightNetInvoiceState _onLoadFailed(LightNetInvoiceState state, Action action) {
  final LightNetInvoiceState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
