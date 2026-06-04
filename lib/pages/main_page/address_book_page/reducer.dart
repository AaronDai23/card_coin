import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AddressBookState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AddressBookState>>{
      AddressBookAction.onInit: _onInit,
      AddressBookAction.onLoadFailure: _onLoadFailure,
      AddressBookAction.onUpdateItems: _onUpdateItems,
    },
  );
}

AddressBookState _onInit(AddressBookState state, Action action) {
  final AddressBookState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..items = action.payload;
  return newState;
}

AddressBookState _onLoadFailure(AddressBookState state, Action action) {
  final AddressBookState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

AddressBookState _onUpdateItems(AddressBookState state, Action action) {
  final AddressBookState newState = state.clone()..items = action.payload;
  return newState;
}
