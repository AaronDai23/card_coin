import 'package:fish_redux/fish_redux.dart';

import '../../../bean/balance_detail.dart';
import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../pages/main_page/hd_wallet_list_page/item_state.dart';
import '../../../pages/main_page/hd_wallet_page/cryptos_price.dart';

//TODO replace with your own action
enum CardWalletListAction {
  action,
  updateCurrencyList,
  getTotalBalance,
  syncWallet,
  getNewestPrices,
  loadCardInfo,
  refresh,
  showNickNameAlert,
  updateNickName,
  updateCurrency,
  blockchainClick,
  itemLongPress,
  updateNewestPrice,
  loadSuccess,
  lightningNetDetail,
  lightningNet,
  loadFailure,
  updateBlockchainSelected,
  updatelightningNetValue,
  startTime,
  updateTime,
  stopTime,
  checkIncompatible,
  showIncompatible,
  showIncompatibleHelp,
}

class CardWalletListActionCreator {
  static Action onAction() {
    return const Action(CardWalletListAction.action);
  }

  static Action onIncompatibleAction() {
    return const Action(CardWalletListAction.checkIncompatible);
  }

  static Action onShowIncompatibleAction(bool isIncompatible) {
    return Action(CardWalletListAction.showIncompatible,
        payload: isIncompatible);
  }

  static Action onShowIncompatibleHelpAction() {
    return const Action(CardWalletListAction.showIncompatibleHelp);
  }

  static Action onBlockchainClick(CurrencyInfo currencyInfo) {
    return Action(CardWalletListAction.blockchainClick, payload: currencyInfo);
  }

  static Action onItemLongPress(CurrencyInfo wallet) {
    return Action(CardWalletListAction.itemLongPress, payload: wallet);
  }

  static Action onShowNickNameAlert() {
    return const Action(CardWalletListAction.showNickNameAlert);
  }

  static Action onUpdateNickName(CardInfo cardInfo) {
    return Action(CardWalletListAction.updateNickName, payload: cardInfo);
  }

  static Action onUpdateCurrency() {
    return const Action(CardWalletListAction.updateCurrency);
  }

  static Action onRefresh() {
    return const Action(CardWalletListAction.refresh);
  }

  static Action onUpdateCurrencyList(List<CurrencyItemState> currencyList) {
    return Action(CardWalletListAction.updateCurrencyList,
        payload: currencyList);
  }

  static Action onGetTotalBalance() {
    return const Action(CardWalletListAction.getTotalBalance);
  }

  static Action onUpdateTime(int second) {
    return Action(CardWalletListAction.updateTime, payload: second);
  }

  static Action onStartTime() {
    return const Action(CardWalletListAction.startTime);
  }

  static Action onStopTime() {
    return const Action(CardWalletListAction.stopTime);
  }

  static Action onSyncWallet(List<CurrencyItemState> currencyList) {
    return Action(CardWalletListAction.syncWallet, payload: currencyList);
  }

  static Action onGetNewestPrices(List<String> codes) {
    return Action(CardWalletListAction.getNewestPrices, payload: codes);
  }

  static Action onLoadCardInfo() {
    return const Action(CardWalletListAction.loadCardInfo);
  }

  static Action onUpdateNewestPrice(Map<String, CryptosPrice> cryptosPriceMap) {
    return Action(CardWalletListAction.updateNewestPrice,
        payload: cryptosPriceMap);
  }

  static Action onLoadSuccess(CardDetail cardDetail) {
    return Action(CardWalletListAction.loadSuccess, payload: cardDetail);
  }

  static Action onLightningNetAction() {
    return const Action(CardWalletListAction.lightningNet);
  }

  static Action onLightningNetDetailAction(String uid) {
    return Action(CardWalletListAction.lightningNetDetail, payload: uid);
  }

  static Action onUpdateBlockchainSelected(
      CurrencyInfo currencyInfo, bool isSelected) {
    return Action(CardWalletListAction.updateBlockchainSelected,
        payload: {'currencyInfo': currencyInfo, 'isSelected': isSelected});
  }

  static Action onUpdatelightningNetValueAction(FlashBalance flashBalance) {
    return Action(CardWalletListAction.updatelightningNetValue,
        payload: flashBalance);
  }
}
