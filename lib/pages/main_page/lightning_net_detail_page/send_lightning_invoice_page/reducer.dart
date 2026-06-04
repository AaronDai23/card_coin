import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SendLightningInvoiceState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SendLightningInvoiceState>>{
      // SendLightningInvoiceAction.action: _onAction,
      SendLightningInvoiceAction.updateLoading: _onUpdateLoading,
      SendLightningInvoiceAction.updateInvoiceInfo: _onUpdateInvoiceInfo,
    },
  );
}

SendLightningInvoiceState _onUpdateLoading(SendLightningInvoiceState state, Action action) {
  final SendLightningInvoiceState newState = state.clone()..isLoading = action.payload;
  return newState;
}

SendLightningInvoiceState _onUpdateInvoiceInfo(SendLightningInvoiceState state, Action action) {
  final SendLightningInvoiceState newState = state.clone()
    ..isLoading = false
    ..invoiceInfo = action.payload;
  return newState;
}
