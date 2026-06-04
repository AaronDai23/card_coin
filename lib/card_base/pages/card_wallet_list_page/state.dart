import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../bean/balance_detail.dart';
import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../bean/card_info_bean.dart';
import '../../../bean/fiat_bean.dart';
import '../../../pages/main_page/hd_wallet_list_page/item_state.dart';
import '../../../pages/main_page/hd_wallet_page/cryptos_price.dart';
import '../../../widget/base_page_loading.dart';
import 'package:collection/collection.dart';

class CardWalletListState extends LoadPageState<CardWalletListState> {
  late CardInfo cardInfo;
  StreamSubscription? subscription;
  List<CurrencyItemState> currencyList = [];
  late FiatInfo currentFiat;
  RefreshController refreshController = RefreshController();
  String cryptoTotalPrice = '0.00';
  Map<String, CryptosPrice> cryptosPriceMap = {};
  late bool showLightningNet; // 是否展示闪电网络

  FlashBalance? flashBalanceDetail;

  Timer? homeTimer;

  int homeSeconds = 60;

  late String incompatibleTip = ""; // 是否兼容提示

  late bool isIncompatible = false; // 是否不兼容 默认为false
  late bool isShowBtc = true; // 默认展示

  bool needShowInitStatus = false;

  @override
  CardWalletListState clone() {
    return CardWalletListState()
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..subscription = subscription
      ..cardInfo = cardInfo
      ..currentFiat = currentFiat
      ..currencyList = currencyList
      ..cryptosPriceMap = cryptosPriceMap
      ..cryptoTotalPrice = cryptoTotalPrice
      ..refreshController = refreshController
      ..showLightningNet = showLightningNet
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..flashBalanceDetail = flashBalanceDetail
      ..homeTimer = homeTimer
      ..isIncompatible = isIncompatible
      ..incompatibleTip = incompatibleTip
      ..isShowBtc = isShowBtc
      ..needShowInitStatus = needShowInitStatus
      ..homeSeconds = homeSeconds;
  }
}

CardWalletListState initState(Map<String, dynamic>? args) {
  CardInfo cardInfo = args!['cardInfo'];
  print("CardWalletListPage-initState-cardInfo:${cardInfo.toJson()}");
  CurrencyInfo? currencyInfo = cardInfo.wallets.firstWhereOrNull(
      (element) => element.currencyData.id.toLowerCase() == "btc");
  bool showLightningNet = false;
  if (currencyInfo != null && currencyInfo.isHide != true) {
    showLightningNet = true;
  }
  bool needShowInitStatus = false;
  needShowInitStatus = args['needShowInitStatus'] ?? false;

  final initialCurrencyList = cardInfo.wallets
      .map((e) => CurrencyItemState()..bean = e)
      .toList()
      .cast<CurrencyItemState>();

  return CardWalletListState()
    ..cardInfo = cardInfo
    ..currentFiat = cardInfo.fiatInfo ?? FiatInfo.empty()
    ..showLightningNet = showLightningNet
    ..needShowInitStatus = needShowInitStatus
    ..isShowBtc = showLightningNet
    ..currencyList = initialCurrencyList
    ..loadStatus = LoadType.loadSuccess;
}
