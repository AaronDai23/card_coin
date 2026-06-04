import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/bean/update_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../bean/blockchain/bit_coin_transaction_info.dart';

//TODO replace with your own action
enum MainAction {
  sign,
  scanCard,
  updateCardInfo,
  biometricClick,
  updateSupportBiometric,
  updateCardList,
  loadDefaultCurrency,
  updateCurrencyList,
  showLoading,
  loadSuccess,
  loadFailed,
  upgrade,
  upgradeApp,
  allcrypto,
  ndefDomain,
  healCheck,
  getInitBlockchain
}

class MainActionCreator {
  static Action onSign() {
    return const Action(MainAction.sign);
  }

  static Action onHealCheck() {
    return const Action(MainAction.healCheck);
  }

  static Action onUpdateCurrencyList(List<CurrencyInfo> currencyList) {
    return Action(MainAction.updateCurrencyList, payload: currencyList);
  }

  static Action onLoadDefaultCurrency() {
    return const Action(MainAction.loadDefaultCurrency);
  }

  static Action onScanCard() {
    return const Action(MainAction.scanCard);
  }

  static Action onBiometricClick() {
    return const Action(MainAction.biometricClick);
  }

  static Action onUpdateSupportBiometric(bool isSupport) {
    return Action(MainAction.updateSupportBiometric, payload: isSupport);
  }

  static Action onUpdateCardList(List<CardInfo> cardInfoList) {
    return Action(MainAction.updateCardList, payload: cardInfoList);
  }

  static Action updateCardInfo() {
    return const Action(MainAction.updateCardInfo);
  }

  static Action onShowLoading() {
    return const Action(MainAction.showLoading);
  }

  static Action onLoadSuccess(List<CurrencyInfo> currencyList) {
    return Action(MainAction.loadSuccess, payload: currencyList);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(MainAction.loadFailed, payload: errorMsg);
  }

  static Action onUpGrade() {
    return const Action(MainAction.upgrade);
  }

  static Action onAllcrypto() {
    return const Action(MainAction.allcrypto);
  }

  static Action onNdefDomain() {
    return const Action(MainAction.ndefDomain);
  }

  static Action onUpgradeApp(UpdateInfo updateInfo) {
    return Action(MainAction.upgradeApp, payload: updateInfo);
  }


  static Action onGetInitBlockchain(String uuid) {
    return Action(MainAction.getInitBlockchain, payload: uuid);
  }


}
