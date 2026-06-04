import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/item_state.dart';
import 'package:fish_redux/fish_redux.dart';

import '../hd_wallet_page/cryptos_price.dart';

//TODO replace with your own action
enum HDWalletListAction {
  action,
  addBlockchainClick,
  loadCardInfo,
  loadFailure,
  loadSuccess,
  updateCurrencyList,
  blockchainClick,
  updateBlockchainSelected,
  getNewestPrices,
  updateNewestPrice,
  showNickNameAlert,
  updateNickName,
  updateCurrency,
  showCardInfoList,
  changeWallet,
  addWalletClick,
  removeCard,
  getTotalBalance,
  updateCryptosPriceMap,
  updateTotalPrice,
  updatCardAfterRemoveCard,
  loadDefaultCurrency,
  scanCard,
  itemLongPress,
  refresh,
  syncWallet,
  loadAllcryptoList,
  addBlockchainTip,
  ndefDomain,
  lightningNet,
  updatelightningNetValue,
  lightningNetDetail,
  startTime,
  stopTime,
  updateTime
}

class HDWalletListActionCreator {
  static Action onAction() {
    return const Action(HDWalletListAction.action);
  }

  static Action onUpdateNewestPrice(Map<String, CryptosPrice> cryptosPriceMap) {
    return Action(HDWalletListAction.updateNewestPrice,
        payload: cryptosPriceMap);
  }

  static Action onGetNewestPrices(List<String> codes) {
    return Action(HDWalletListAction.getNewestPrices, payload: codes);
  }

  static Action onUpdateBlockchainSelected(
      CurrencyInfo currencyInfo, bool isSelected) {
    return Action(HDWalletListAction.updateBlockchainSelected,
        payload: {'currencyInfo': currencyInfo, 'isSelected': isSelected});
  }

  static Action onBlockchainClick(CurrencyInfo currencyInfo) {
    return Action(HDWalletListAction.blockchainClick, payload: currencyInfo);
  }

  static Action onUpdateCurrencyList(List<CurrencyItemState> currencyList) {
    return Action(HDWalletListAction.updateCurrencyList, payload: currencyList);
  }

  static Action onLoadCardInfo() {
    return const Action(HDWalletListAction.loadCardInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(HDWalletListAction.loadFailure, payload: errorMsg);
  }

  static Action onLoadSuccess(CardDetail cardDetail) {
    return Action(HDWalletListAction.loadSuccess, payload: cardDetail);
  }

  static Action onAddBlockchainClick() {
    return const Action(HDWalletListAction.addBlockchainClick);
  }

  static Action onShowNickNameAlert() {
    return const Action(HDWalletListAction.showNickNameAlert);
  }

  static Action onUpdateNickName(CardInfo cardInfo) {
    return Action(HDWalletListAction.updateNickName, payload: cardInfo);
  }

  static Action onUpdateCurrency() {
    return const Action(HDWalletListAction.updateCurrency);
  }

  static Action onShowCardInfoList() {
    return const Action(HDWalletListAction.showCardInfoList);
  }

  static Action onChangeWallet(CardInfo cardInfo) {
    return Action(HDWalletListAction.changeWallet, payload: cardInfo);
  }

  static Action onAddWalletClick() {
    return const Action(HDWalletListAction.addWalletClick);
  }

  static Action onScanCardClick(List<CurrencyInfo> currencyInfos) {
    return Action(HDWalletListAction.scanCard, payload: currencyInfos);
  }

  static Action onRemoveCard(CardInfo cardInfo) {
    return Action(HDWalletListAction.removeCard, payload: cardInfo);
  }

  static Action onGetTotalBalance() {
    return const Action(HDWalletListAction.getTotalBalance);
  }

  static Action onUpdatePriceMap(Map<String, CryptosPrice> map) {
    return Action(HDWalletListAction.updateCryptosPriceMap, payload: map);
  }

  static Action onUpdateTotalPrice(String cryptoTotalPrice) {
    return Action(HDWalletListAction.updateTotalPrice,
        payload: cryptoTotalPrice);
  }

  static Action onUpdatCardAfterRemoveCard(List<CardInfo> cardInfos) {
    return Action(HDWalletListAction.updatCardAfterRemoveCard,
        payload: cardInfos);
  }

  static Action onItemLongPress(CurrencyInfo wallet) {
    return Action(HDWalletListAction.itemLongPress, payload: wallet);
  }

  static Action onRefresh() {
    return const Action(HDWalletListAction.refresh);
  }

  static Action onSyncWallet(List<CurrencyItemState> currencyList) {
    return Action(HDWalletListAction.syncWallet, payload: currencyList);
  }

  static Action onLoadAllcryptoList() {
    return const Action(HDWalletListAction.loadAllcryptoList);
  }

  static Action onAddBlockchainTip() {
    return const Action(HDWalletListAction.addBlockchainTip);
  }

  static Action onNdefDomain() {
    return const Action(HDWalletListAction.ndefDomain);
  }

  static Action onLightningNetAction() {
    return const Action(HDWalletListAction.lightningNet);
  }

  static Action onUpdatelightningNetValueAction(FlashBalance flashBalance) {
    return Action(HDWalletListAction.updatelightningNetValue,
        payload: flashBalance);
  }

  static Action onLightningNetDetailAction(String uid) {
    return Action(HDWalletListAction.lightningNetDetail, payload: uid);
  }

  static Action onUpdateTime(int second) {
    return Action(HDWalletListAction.updateTime, payload: second);
  }

  static Action onStartTime() {
    return const Action(HDWalletListAction.startTime);
  }

  static Action onStopTime() {
    return const Action(HDWalletListAction.stopTime);
  }
}
