import 'dart:ui';

import 'package:card_coin/bean/coin_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

class InvestmentCoinState implements GlobalBaseState<InvestmentCoinState> {
  List<CoinInfo> fiats = [];
  int currentFiatIndex = 0;
  late CoinInfo currentFiat;
  @override
  InvestmentCoinState clone() {
    return InvestmentCoinState()
      ..currentFiat = currentFiat
      ..currentFiatIndex = currentFiatIndex
      ..fiats = fiats;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

InvestmentCoinState initState(Map<String, dynamic>? args) {
  List<CoinInfo> fiats = [];
  int currentFiatIndex = 0;

  currentFiatIndex = args!['currentFiatIndex'];
  fiats = args['coinInfos'];
  CoinInfo currentFiat = fiats[currentFiatIndex];
  return InvestmentCoinState()
    ..currentFiat = currentFiat
    ..currentFiatIndex = currentFiatIndex
    ..fiats = fiats;
}
