import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'item_state.dart';
import 'state.dart';

Reducer<HDWalletListState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HDWalletListState>>{
      HDWalletListAction.action: _onAction,
      HDWalletListAction.loadFailure: _onLoadFailure,
      HDWalletListAction.loadSuccess: _onLoadSuccess,
      HDWalletListAction.updateCurrencyList: _onUpdateCurrencyList,
      HDWalletListAction.updateBlockchainSelected: _onUpdateBlockchainSelected,
      HDWalletListAction.updateNewestPrice: _onUpdateNewestPrice,
      HDWalletListAction.updateNickName: _onUpdateNickName,
      HDWalletListAction.updatCardAfterRemoveCard: _onUpdatCardAfterRemoveCard,
      HDWalletListAction.updatelightningNetValue: _onUpdatelightningNetValue,
      HDWalletListAction.updateTime: _onUpdateSecondValue
    },
  );
}

HDWalletListState _onAction(HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone();
  return newState;
}

HDWalletListState _onUpdateNewestPrice(HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone()
    ..cryptosPriceMap = action.payload;
  return newState;
}

HDWalletListState _onUpdateCurrencyList(
    HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone()
    ..currencyList = action.payload;
  return newState;
}

HDWalletListState _onUpdateBlockchainSelected(
    HDWalletListState state, Action action) {
  CurrencyInfo currencyInfo = action.payload['currencyInfo'];
  bool isSelected = action.payload['isSelected'];
  final HDWalletListState newState = state.clone()
    ..currencyList = state.currencyList.map((e) {
      if (currencyInfo == e.bean) {
        return e.clone()..isSelected = isSelected;
      } else {
        return e;
      }
    }).toList();
  return newState;
}

HDWalletListState _onLoadFailure(HDWalletListState state, Action action) {
  String errorMsg = action.payload;
  final HDWalletListState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = errorMsg;
  return newState;
}

HDWalletListState _onLoadSuccess(HDWalletListState state, Action action) {
  CardDetail cardDetail = action.payload;
  final cardInfo = state.cardInfo.copyWidth(cardDetail: cardDetail);
  if (cardInfo.cardDetail!.alias != null) {
    cardInfo.nickName = cardInfo.cardDetail!.alias!;
  }

  final HDWalletListState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..currencyList = cardInfo.wallets
        .map((e) => CurrencyItemState()..bean = e)
        .toList()
        .cast()
    ..cardInfo = cardInfo;
  print("_onLoadSuccess1:${{DateTime.now()}}");
  return newState;
}

HDWalletListState _onUpdateNickName(HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone();
  CardInfo cardInfo = action.payload;
  newState.cardInfoList.map((e) {
    if (cardInfo.cardId == e.cardId) {
      e.nickName = cardInfo.nickName;
    }
    return e;
  });
  print('刷新钱包别名');
  return newState;
}

HDWalletListState _onUpdatCardAfterRemoveCard(
    HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone();
  List<CardInfo> cardInfos = action.payload;
  newState.cardInfoList = cardInfos;
  newState.currentIndex = 0;
  print('刷新删除页面');
  return newState;
}

HDWalletListState _onUpdatelightningNetValue(
    HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone();
  newState.flashBalanceDetail = action.payload;
  return newState;
}

HDWalletListState _onUpdateSecondValue(HDWalletListState state, Action action) {
  final HDWalletListState newState = state.clone();
  newState.homeSeconds = action.payload;
  return newState;
}
