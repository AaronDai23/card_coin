import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/bean/main_page_bean.dart';
import 'package:flutter/material.dart';

class HdRechargeMainState implements GlobalBaseState<HdRechargeMainState> {
  int currentIndex = 0;
  late List<TabItemData> tabList;
  TabController? tabController;
  late CurrencyInfo info;
  int loadType = 0;
  bool isPasswordSet = false;

  @override
  HdRechargeMainState clone() {
    return HdRechargeMainState()
      ..currentIndex = currentIndex
      ..tabController = tabController
      ..info = info
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadType = loadType
      ..isPasswordSet = isPasswordSet
      ..tabList = tabList;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

HdRechargeMainState initState(Map<String, dynamic>? args) {
  CurrencyInfo currencyInfo = args!['currencyInfo'];
  int loadType = args['loadType'];
  bool isPasswordSet = args['isPasswordSet'];

  if (loadType == 0) {
    return HdRechargeMainState()
      ..info = currencyInfo
      ..loadType = loadType
      ..tabList = currencyInfo.networkLists!.map((e) {
        return TabItemData(
            name: e.currencyData.networkId,
            icon: '',
            iconSelected: '',
            page: 'hdRechargePage');
      }).toList();
  } else {
    return HdRechargeMainState()
      ..info = currencyInfo
      ..loadType = loadType
      ..isPasswordSet = isPasswordSet
      ..tabList = currencyInfo.networkLists!.map((e) {
        return TabItemData(
            name: e.currencyData.networkId,
            icon: '',
            iconSelected: '',
            page: 'hdSendPage');
      }).toList();
  }
}
