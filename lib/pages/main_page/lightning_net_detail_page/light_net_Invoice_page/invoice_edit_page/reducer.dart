import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvoiceEditState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvoiceEditState>>{
      InvoiceEditAction.showLoading: _onShowLoading,
      InvoiceEditAction.loadSuccess: _onLoadSuccess,
      InvoiceEditAction.loadFailed: _onLoadFailed,
      InvoiceEditAction.update: _onUpdateAction,
    },
  );
}

InvoiceEditState _onUpdateAction(InvoiceEditState state, Action action) {
  final InvoiceEditState newState = state.clone();
  return newState;
}

InvoiceEditState _onShowLoading(InvoiceEditState state, Action action) {
  final InvoiceEditState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

InvoiceEditState _onLoadSuccess(InvoiceEditState state, Action action) {
  final InvoiceEditState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

InvoiceEditState _onLoadFailed(InvoiceEditState state, Action action) {
  final InvoiceEditState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
