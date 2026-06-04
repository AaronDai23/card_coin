import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

import '../../../global_store/state.dart';

class WriteCardState implements GlobalBaseState<WriteCardState>, PageLoad {
  late TextEditingController textController;
  late TextEditingController uriController;
  late TextEditingController mimeTypeController;
  late TextEditingController mimeDataController;
  late TextEditingController externalDomainController;
  late TextEditingController externalTypeController;
  late TextEditingController externalDataController;
  String cardId = "";
  late CardInfo cardInfo;
  late CurrencyInfo currencyInfo; // 网络下代币/或者公链币
  int index = -1;
  List<CurrencyInfo> currencyInfos = []; // 网络下代币/或者公链币

  String? readData;

  @override
  WriteCardState clone() {
    return WriteCardState()
      ..textController = textController
      ..uriController = uriController
      ..mimeTypeController = mimeTypeController
      ..mimeDataController = mimeDataController
      ..externalDomainController = externalDomainController
      ..externalTypeController = externalTypeController
      ..externalDataController = externalDataController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..cardId = cardId
      ..cardInfo = cardInfo
      ..index = index
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..currencyInfo = currencyInfo
      ..currencyInfos = currencyInfos
      ..readData = readData;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = "";

  @override
  LoadType loadStatus = LoadType.loadSuccess;
}

WriteCardState initState(Map<String, dynamic>? args) {
  CardInfo info = args!["cardInfo"];
  return WriteCardState()
    ..textController = TextEditingController()
    ..uriController = TextEditingController(text: 'https://www.baidu.com')
    ..mimeTypeController = TextEditingController()
    ..mimeDataController = TextEditingController()
    ..externalDomainController = TextEditingController()
    ..externalTypeController = TextEditingController()
    ..cardId = args["cardId"]
    ..cardInfo = info
    ..currencyInfo = info.wallets[0]
    ..externalDataController = TextEditingController();
}
