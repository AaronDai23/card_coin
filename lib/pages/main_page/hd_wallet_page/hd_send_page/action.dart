import 'dart:typed_data';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HdSendAction {
  scanQR,
  amountChange,
  validateAddress,
  updateValid,
  updateNetworks,
  updateNetworkIndex,
  sendSignedHash,
  showPinCodeDialog,
  sendTransaction,
  showNetworks,
  update,
  back,
  showLoading,
  loadSuccess,
  loadFailed,
  showAlert,
  checkData
}

class HdSendActionCreator {
  static Action onScanQR() {
    return const Action(HdSendAction.scanQR);
  }

  static Action onAmountChange(String amount) {
    return Action(HdSendAction.amountChange, payload: amount);
  }

  static Action onValidateAddress(String address) {
    return Action(HdSendAction.validateAddress, payload: address);
  }

  static Action onUpdateValid(bool isValid) {
    return Action(HdSendAction.updateValid, payload: isValid);
  }

  static Action onUpdateNetworks(List<dynamic> list) {
    return Action(HdSendAction.updateNetworks, payload: list);
  }

  static Action onUpdateNetworkIndex(int index) {
    return Action(HdSendAction.updateNetworkIndex, payload: index);
  }

  static Action onSendSignedHash(List<String> signedHashes) {
    return Action(HdSendAction.sendSignedHash, payload: signedHashes);
  }

  static Action onShowPinCodeDialog(List<Uint8List> signHashList) {
    return Action(HdSendAction.showPinCodeDialog, payload: signHashList);
  }

  static Action onSendTransaction() {
    return const Action(HdSendAction.sendTransaction);
  }

  static Action onBack() {
    return const Action(HdSendAction.back);
  }

  static Action onCheckData() {
    return const Action(HdSendAction.checkData);
  }

  static Action onUpdate(CurrencyInfo currency) {
    return Action(HdSendAction.update, payload: currency);
  }

  static Action onShowNetworks(CurrencyInfo currency) {
    return Action(HdSendAction.showNetworks, payload: currency);
  }

  static Action onLoadSuccess(CurrencyInfo currency) {
    return Action(HdSendAction.loadSuccess, payload: currency);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(HdSendAction.loadFailed, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(HdSendAction.showLoading);
  }

  static Action onShowAlert() {
    return const Action(HdSendAction.showAlert);
  }
}
