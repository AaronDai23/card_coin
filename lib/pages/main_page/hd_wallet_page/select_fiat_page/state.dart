
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

class SelectFiatState implements GlobalBaseState<SelectFiatState> {
  List<FiatInfo> fiats = [];
  String searchText = '';
  late FiatInfo currentFiat;
  TextEditingController searchController = TextEditingController();

  @override
  SelectFiatState clone() {
    return SelectFiatState()
      ..fiats = fiats
      ..currentFiat = currentFiat
      ..searchController = searchController
      ..languageResource = languageResource
      ..searchText = searchText;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

SelectFiatState initState(Map<String, dynamic>? args) {
  FiatInfo info = args!['fiatInfo'] ??
      FiatInfo(
          symbol: 'USDT',
          imageUrl: '',
          name: "USDT",
          currentPrice: "1.00",
          scale: '2',
          currency: '');

  return SelectFiatState()..currentFiat = info;
}
