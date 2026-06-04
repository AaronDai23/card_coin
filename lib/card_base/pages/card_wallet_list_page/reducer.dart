
import 'package:fish_redux/fish_redux.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../pages/main_page/hd_wallet_list_page/item_state.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<CardWalletListState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CardWalletListState>>{
      CardWalletListAction.action: _onAction,
      CardWalletListAction.updateNewestPrice: _onUpdateNewestPrice,
      CardWalletListAction.loadFailure: _onLoadFailure,
      CardWalletListAction.loadSuccess: _onLoadSuccess,
      CardWalletListAction.updateBlockchainSelected:
          _onUpdateBlockchainSelected,
      CardWalletListAction.updateNickName: _onUpdateNickName,
      CardWalletListAction.updateCurrencyList: _onUpdateCurrencyList,
      CardWalletListAction.updatelightningNetValue: _onUpdatelightningNetValue,
      CardWalletListAction.updateTime: _onUpdateSecondValue,
      CardWalletListAction.showIncompatible: _onShowIncompatible,
    },
  );
}

CardWalletListState _onAction(CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone();
  return newState;
}

CardWalletListState _onUpdateNewestPrice(
    CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone()
    ..cryptosPriceMap = action.payload;
  return newState;
}

CardWalletListState _onShowIncompatible(
    CardWalletListState state, Action action) {
  print("_onShowIncompatible:${action.payload}");
  final CardWalletListState newState = state.clone()
    ..isIncompatible = action.payload;
  return newState;
}

CardWalletListState _onLoadSuccess(CardWalletListState state, Action action) {
  CardDetail cardDetail = action.payload;
  final cardInfo = state.cardInfo.copyWidth(cardDetail: cardDetail);
  if (cardInfo.cardDetail!.alias != null) {
    cardInfo.nickName = cardInfo.cardDetail!.alias!;
  }
  List<CurrencyInfo> wallets = [];

  if (state.isShowBtc == false) {
    for (var element in cardInfo.wallets) {
      print(
          "cardInfo.wallet.id:${element.currencyData.id},address:${element.address},testnet:${element.isTest}");
      if (element.currencyData.id.toLowerCase() != "btc") {
        wallets.add(element);
      }
    }
  } else {
    wallets = cardInfo.wallets;
  }
  print("_onLoadSuccess_count:${wallets.length}");

  final CardWalletListState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..currencyList =
        wallets.map((e) => CurrencyItemState()..bean = e).toList().cast()
    ..cardInfo = cardInfo;
  print("_onLoadSuccess1:${{DateTime.now()}}");
  return newState;
}

CardWalletListState _onUpdateCurrencyList(
    CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone()
    ..currencyList = action.payload;
  return newState;
}

CardWalletListState _onUpdateBlockchainSelected(
    CardWalletListState state, Action action) {
  CurrencyInfo currencyInfo = action.payload['currencyInfo'];
  bool isSelected = action.payload['isSelected'];
  final CardWalletListState newState = state.clone()
    ..currencyList = state.currencyList.map((e) {
      if (currencyInfo == e.bean) {
        return e.clone()..isSelected = isSelected;
      } else {
        return e;
      }
    }).toList();
  return newState;
}

CardWalletListState _onLoadFailure(CardWalletListState state, Action action) {
  String errorMsg = action.payload;
  final CardWalletListState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = errorMsg;
  return newState;
}

CardWalletListState _onUpdateNickName(
    CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone();
  CardInfo cardInfo = action.payload;
  state.cardInfo.nickName = cardInfo.nickName;
  return newState;
}

CardWalletListState _onUpdatelightningNetValue(
    CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone();
  newState.flashBalanceDetail = action.payload;
  return newState;
}

CardWalletListState _onUpdateSecondValue(
    CardWalletListState state, Action action) {
  final CardWalletListState newState = state.clone();
  newState.homeSeconds = action.payload;
  return newState;
}
