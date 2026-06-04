import 'package:fish_redux/fish_redux.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';

//TODO replace with your own action
enum ScanWalletAction {
  action,
  showLoading,
  loadSuccess,
  loadFailed,
  loadDefaultCurrency,
  scanCard
}

class ScanWalletActionCreator {
  static Action onAction() {
    return const Action(ScanWalletAction.action);
  }

  static Action onShowLoading() {
    return const Action(ScanWalletAction.showLoading);
  }

  static Action onLoadSuccess(List<CurrencyInfo> currencyList) {
    return Action(ScanWalletAction.loadSuccess, payload: currencyList);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(ScanWalletAction.loadFailed, payload: errorMsg);
  }

  static Action onLoadDefaultCurrency() {
    return const Action(ScanWalletAction.loadDefaultCurrency);
  }

  static Action onScanCard() {
    return const Action(ScanWalletAction.scanCard);
  }
}
