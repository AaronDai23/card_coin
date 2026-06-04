import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'item_state.dart';
import 'state.dart';

Reducer<SelectCurrencyState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SelectCurrencyState>>{
      SelectCurrencyAction.action: _onAction,
      SelectCurrencyAction.updateCoinList: _onUpdateCoinList,
      SelectCurrencyAction.switchChanged: _onSwitchChanged,
      SelectCurrencyAction.showLoading: _onShowLoading,
      SelectCurrencyAction.loadSuccess: _onLoadSuccess,
      SelectCurrencyAction.loadFailed: _onLoadFailed,
      SelectCurrencyAction.addItem: _onTextChanged,
    },
  );
}

SelectCurrencyState _onAction(SelectCurrencyState state, Action action) {
  final SelectCurrencyState newState = state.clone();
  return newState;
}

SelectCurrencyState _onShowLoading(SelectCurrencyState state, Action action) {
  final SelectCurrencyState newState = state.clone()
    ..loadStatus = LoadType.loading;
  return newState;
}

SelectCurrencyState _onLoadSuccess(SelectCurrencyState state, Action action) {
  List<NetworkItemState> coinList = action.payload;
  String selectedStatusStr = coinList.map((e) => e.isSelected).join(',');
  final SelectCurrencyState newState = state.clone()
    ..coinList = coinList
    ..selectedStatusStr = selectedStatusStr
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

SelectCurrencyState _onLoadFailed(SelectCurrencyState state, Action action) {
  final SelectCurrencyState newState = state.clone()
    // ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

SelectCurrencyState _onUpdateCoinList(
    SelectCurrencyState state, Action action) {
  final SelectCurrencyState newState = state.clone()..coinList = action.payload;
  return newState;
}

SelectCurrencyState _onSwitchChanged(SelectCurrencyState state, Action action) {
  bool isSelected = action.payload['isSelected'];
  String id = action.payload['id'];
  final coinList = state.coinList
      .map((e) {
        if (e.bean.id == id) {
          return e.clone()..isSelected = isSelected;
        }
        return e;
      })
      .toList()
      .cast<NetworkItemState>();

  final SelectCurrencyState newState = state.clone()
    ..coinList = coinList
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

SelectCurrencyState _onTextChanged(SelectCurrencyState state, Action action) {
  final SelectCurrencyState newState = state.clone()
    ..searchText = action.payload;

  return newState;
}
