import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:nfc_manager/nfc_manager.dart';

//TODO replace with your own action
enum WriteCardAction {
  writeCard,
  readCard,
  updateData,
  writeClick,
  showCurrencyInfos,
  showLoading,
  loadSuccess,
  loadFailed,
  showNetworks,
  update,
  back
}

class WriteCardActionCreator {
  static Action onWriteCard(NdefMessage message) {
    return Action(WriteCardAction.writeCard, payload: message);
  }

  static Action onReadCard() {
    return const Action(WriteCardAction.readCard);
  }

  static Action onUpdateData(String data) {
    return Action(WriteCardAction.updateData, payload: data);
  }

  static Action onWriteClick() {
    return const Action(WriteCardAction.writeClick);
  }

  static Action onUpate(CurrencyInfo data) {
    return Action(WriteCardAction.update, payload: data);
  }

  static Action onShowCurrencyInfos(CardInfo cardInfo) {
    return Action(WriteCardAction.showCurrencyInfos, payload: cardInfo);
  }

  static Action onLoadSuccess(CurrencyInfo data) {
    return Action(WriteCardAction.loadSuccess, payload: data);
  }

  static Action onLoadFail() {
    return const Action(WriteCardAction.loadSuccess);
  }

  static Action onShowLoading() {
    return const Action(WriteCardAction.showLoading);
  }

  static Action onBack() {
    return const Action(WriteCardAction.back);
  }
}
