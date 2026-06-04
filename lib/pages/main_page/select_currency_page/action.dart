import 'package:card_coin/bean/coin_message.dart';
import 'package:card_coin/pages/main_page/select_currency_page/item_state.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SelectCurrencyAction {
  action,
  updateCoinList,
  switchChanged,
  saveClick,
  loadTestData,
  loadData,
  showLoading,
  loadSuccess,
  loadFailed,
  textChanged,
  refresh,
  loading,
  addItem,
  showNotSaveTips
}

class SelectCurrencyActionCreator {

  static Action onAction() {
    return const Action(SelectCurrencyAction.action);
  }

  static Action onShowNotSaveTips() {
    return const Action(SelectCurrencyAction.showNotSaveTips);
  }

  static Action onAddItem(NetworkItemState state) {
    return Action(SelectCurrencyAction.addItem, payload: state);
  }

  static Action onShowLoading() {
    return const Action(SelectCurrencyAction.showLoading);
  }

  static Action onLoadSuccess(List<NetworkItemState> coinList) {
    return Action(SelectCurrencyAction.loadSuccess, payload: coinList);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(SelectCurrencyAction.loadFailed, payload: errorMsg);
  }

  static Action onLoadData() {
    return const Action(SelectCurrencyAction.loadData);
  }

  static Action onLoadTestData() {
    return const Action(SelectCurrencyAction.loadTestData);
  }

  static Action onSaveClick() {
    return const Action(SelectCurrencyAction.saveClick);
  }

  static Action onUpdateCoinList(List<CurrencyCoin> coinList) {
    return Action(SelectCurrencyAction.updateCoinList, payload: coinList);
  }

  static Action onSwitchChanged(String id, bool isSelected) {
    return Action(SelectCurrencyAction.switchChanged,
        payload: {'id': id, 'isSelected': isSelected});
  }

  static Action onTextChanged(String text) {
    return Action(SelectCurrencyAction.textChanged, payload: text);
  }

  static Action onRefresh() {
    return const Action(SelectCurrencyAction.refresh);
  }

  static Action onLoading() {
    return const Action(SelectCurrencyAction.loading);
  }
}
