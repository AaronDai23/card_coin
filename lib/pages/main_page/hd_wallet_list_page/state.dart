import 'dart:async';
import 'dart:ui';

import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../bean/card_info_bean.dart';
import '../hd_wallet_page/cryptos_price.dart';
import 'item_state.dart';
import 'package:collection/collection.dart';

class HDWalletListState implements LoadPageState<HDWalletListState> {
  late List<CardInfo> cardInfoList;
  late List<CurrencyInfo> cryptoList;
  int currentIndex = 0;
  StreamSubscription? subscription;
  String ndefLink = "";
  bool showLightningNet = false; // 是否展示闪电网络
  String lightningNetId = "";
  CardInfo get cardInfo => cardInfoList[currentIndex];

  String cryptoTotalPrice = '0.00';
  Map<String, CryptosPrice> cryptosPriceMap = {};

  FiatInfo currentFiat = FiatInfo(
      symbol: 'USDT',
      imageUrl: '',
      name: "USDT",
      currentPrice: "1.00",
      scale: '2',
      currency: '\$');

  set cardInfo(CardInfo cardInfo) {
    cardInfoList[currentIndex] = cardInfo;
  }

  RefreshController refreshController = RefreshController();
  List<CurrencyItemState> currencyList = [];

  FlashBalance? flashBalanceDetail;

  Timer? homeTimer;

  int homeSeconds = 60;

  @override
  HDWalletListState clone() {
    return HDWalletListState()
      ..subscription = subscription
      ..cardInfoList = cardInfoList
      ..currentIndex = currentIndex
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..currencyList = currencyList
      ..cryptoTotalPrice = cryptoTotalPrice
      ..refreshController = refreshController
      ..cryptosPriceMap = cryptosPriceMap
      ..ndefLink = ndefLink
      ..showLightningNet = showLightningNet
      ..lightningNetId = lightningNetId
      ..homeSeconds = homeSeconds
      ..homeTimer = homeTimer
      ..flashBalanceDetail = flashBalanceDetail
      // ..cryptoList = cryptoList
      ..currentFiat = currentFiat;
  }

  @override
  String errorMsg = '';

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;
}

HDWalletListState initState(Map<String, dynamic>? args) {
  List<CardInfo> cardInfoList = args!['cardInfoList'];
  int currentIndex = cardInfoList.indexWhere((element) => element.isSelected);
  if (currentIndex == -1) {
    currentIndex = 0;
  }
  var state = HDWalletListState();

  CardInfo info = cardInfoList[currentIndex];
  CurrencyInfo? currencyInfo = info.wallets.firstWhereOrNull(
      (element) => element.currencyData.id.toLowerCase() == "btc");
  bool showLightningNet = false;
  if (currencyInfo != null) {
    showLightningNet = true;
    // lightningNetId = currencyInfo.currencyData.networkId;
  }

  if (info.fiatInfo != null) {
    state.currentFiat = info.fiatInfo!;
  }
  return HDWalletListState()
    ..currentIndex = currentIndex
    ..showLightningNet = showLightningNet
    // ..lightningNetId = lightningNetId
    ..cardInfoList = cardInfoList;
}
