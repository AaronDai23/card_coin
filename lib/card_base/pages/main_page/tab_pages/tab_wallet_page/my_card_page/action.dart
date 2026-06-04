import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/bean/sales_data.dart';
import 'package:card_coin/card_base/bean/dapp_info.dart';
import 'package:fish_redux/fish_redux.dart';

enum MyCardAction {
  loadData,
  loadSuccess,
  loadFailure,
  showLoading,
  setCardAmount,
  updateCardInfo,
  scanCardClick,
  loadCardInfo,
  pushWalletPage,
  addHoldCard,
  refreshHoldCard,
  clearCardDetail,
  refreshAddHoldCardStatus,
  handlScanCardClick,
  investmentlist,
  investmentExpanded,
  pushInvestmentActvite,
  exchangSwitch,
  deletedCard,
  updateCardAfterDelete,
  updateCurrentNum,
  updateViewAfterUpdateCurrentNum,
  changeBgcolorInReTap,
  changeVerticalLines,
  resetActiveBtn,
  dapplist,
  dappDetail,
  reloadMainData,
  mingeCardClick,
  pushOneWalletPage,
  onLoadMessageDetail,
  gotoChainStamp,
  getkline,
  kLine,
  updateFiat,
  updateCurrency,
  loadCurrencyInfo,
  cryptoTotalPrice,
}

class MyCardActionCreator {
  static Action onLoadData({bool isLoadMore = false}) {
    return Action(MyCardAction.loadData, payload: isLoadMore);
  }

  static Action onLoadSuccess({SmartCardDetail? cardDetail}) {
    return Action(MyCardAction.loadSuccess, payload: cardDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MyCardAction.loadFailure, payload: errorMsg);
  }

  static Action onExpanded() {
    return const Action(MyCardAction.investmentExpanded);
  }

  static Action onShowLoading() {
    return const Action(MyCardAction.showLoading);
  }

  static Action onRetBtn() {
    return const Action(MyCardAction.resetActiveBtn);
  }

  static Action onInvestmentPage(String cardId) {
    return Action(MyCardAction.investmentlist, payload: cardId);
  }

  static Action onScanCardClick() {
    return const Action(MyCardAction.scanCardClick);
  }

  static Action onMingeDetailClick() {
    return const Action(MyCardAction.mingeCardClick);
  }

  static Action onhandlScanCardClick() {
    return const Action(MyCardAction.handlScanCardClick);
  }

  static Action onDeleteClick(String cardCustemId) {
    return Action(MyCardAction.deletedCard, payload: cardCustemId);
  }

  static Action onRefreshHoldCard() {
    return const Action(MyCardAction.refreshHoldCard);
  }

  static Action onRefreshAddHoldCardStatus(String uid) {
    return Action(MyCardAction.refreshAddHoldCardStatus, payload: uid);
  }

  static Action onSetCardAmount(String id, int amount) {
    return Action(MyCardAction.setCardAmount,
        payload: {'id': id, 'amount': amount});
  }

  static Action onUpdateCardInfo(String id, num amount) {
    return Action(MyCardAction.updateCardInfo,
        payload: {'id': id, 'amount': amount});
  }

  static Action onLoadCardInfo(String cardId) {
    return Action(MyCardAction.loadCardInfo, payload: cardId);
  }

  static Action onAddHoldCard(String cardId, {bool showSuccessToast = true}) {
    return Action(MyCardAction.addHoldCard,
        payload: {'cardId': cardId, 'showSuccessToast': showSuccessToast});
  }

  static Action onPushWalletPage(String cardId) {
    return Action(MyCardAction.pushWalletPage, payload: cardId);
  }

  static Action onPushOneWalletPage() {
    return const Action(MyCardAction.pushOneWalletPage);
  }

  static Action onClearCardDetail() {
    return const Action(MyCardAction.clearCardDetail);
  }

  static Action onPushInvestmentActviteClick(String uid) {
    return Action(MyCardAction.pushInvestmentActvite, payload: uid);
  }

  static Action onExchangeCardSwitch(bool value) {
    return Action(MyCardAction.exchangSwitch, payload: value);
  }

  static Action onUpdateCurNum(double curValue) {
    return Action(MyCardAction.updateCurrentNum, payload: curValue);
  }

  static Action onUpdateViewAfterUpdateCurrentNum(List arr) {
    return Action(MyCardAction.updateViewAfterUpdateCurrentNum, payload: arr);
  }

  static Action onUpdatechangeVerticalLines() {
    return const Action(MyCardAction.changeVerticalLines);
  }

  static Action onChangeBgcolorInReTap(bool isWhite) {
    return Action(MyCardAction.changeBgcolorInReTap, payload: isWhite);
  }

  static Action onGetDapplist() {
    return const Action(MyCardAction.dapplist);
  }

  static Action onDappDetail(DappInfo info) {
    return Action(MyCardAction.dappDetail, payload: info);
  }

  static Action onReloadMainData() {
    return const Action(MyCardAction.reloadMainData);
  }

  static Action onLoadMessageDetail(CoinMessageDetail messageDetail) {
    return Action(MyCardAction.onLoadMessageDetail, payload: messageDetail);
  }

  static Action onGotoChainStamp() {
    return const Action(MyCardAction.gotoChainStamp);
  }

  static Action onGetKLine(String code) {
    return Action(MyCardAction.getkline, payload: code);
  }

  static Action onKline(List<SalesData> lineDatas) {
    return Action(MyCardAction.kLine, payload: lineDatas);
  }

  static Action onUpdateFiat(FiatInfo currentFiat) {
    return Action(MyCardAction.updateFiat, payload: currentFiat);
  }

  static Action onLoadCurrencyInfo() {
    return const Action(MyCardAction.loadCurrencyInfo);
  }

  static Action onUpdateCurrency() {
    return const Action(MyCardAction.updateCurrency);
  }

  static Action onCryptoTotalPrice(String cryptoTotalPrice) {
    return Action(MyCardAction.cryptoTotalPrice, payload: cryptoTotalPrice);
  }
}
