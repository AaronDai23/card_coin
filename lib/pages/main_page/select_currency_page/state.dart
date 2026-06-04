import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pages/main_page/select_currency_page/item_state.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectCurrencyState implements GlobalBaseState<SelectCurrencyState> {
  List<NetworkItemState> coinList = [];
  int page = 1;
  late List<CurrencyInfo> selectCurrencyList;
  RefreshController refreshController = RefreshController();
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  String uid = '';
  ///记录初始币种列表选中状态，用于后退时判断币种列表有没有更改
  String selectedStatusStr = '';
  @override
  SelectCurrencyState clone() {
    return SelectCurrencyState()
      ..coinList = coinList
      ..selectCurrencyList = selectCurrencyList
      // ..loadStatus = loadStatus
      // ..errorMsg = errorMsg
      ..page = page
      ..selectedStatusStr = selectedStatusStr
      ..searchController = searchController
      ..searchText = searchText
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..uid = uid
      ..refreshController = refreshController;
  }

  // @override
  // String errorMsg = '';

  // @override
  LoadType loadStatus = LoadType.loading;

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

SelectCurrencyState initState(Map<String, dynamic>? args) {
  List<CurrencyInfo> selectCurrencyList = args!['currencyList'];
  String uid = args['uid'];
  return SelectCurrencyState()
    ..uid = uid
    ..selectCurrencyList = selectCurrencyList;
}
