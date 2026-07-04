import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:local_auth/local_auth.dart';

import '../../global_store/state.dart';

class MainState implements GlobalBaseState<MainState>, PageLoad {
  bool supportBiometric = false;
  LocalAuthentication auth = LocalAuthentication();
  // List<CardInfo> cardInfoList = [];
  List<CurrencyInfo> defaultCurrencyList = [];
  List<CurrencyInfo> cryptoList = [];
  List<String> selectItem = [];
  int count = 0;
  String domain = "";
  @override
  MainState clone() {
    return MainState()
      ..auth = auth
      ..defaultCurrencyList = defaultCurrencyList
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..supportBiometric = supportBiometric
      // ..cardInfoList = cardInfoList
      ..errorMsg = errorMsg
      ..count = count
      ..domain = domain
      ..loadStatus = loadStatus
      ..selectItem = selectItem
      ..cryptoList = cryptoList;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;
}

MainState initState(Map<String, dynamic>? args) {
  return MainState();
}
