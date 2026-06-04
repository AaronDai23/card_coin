import 'dart:async';

import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/cupertino.dart';

import '../../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../../global_store/state.dart';

class HdSendState implements GlobalBaseState<HdSendState>, PageLoad {
  late CurrencyInfo currencyInfo; // 网络下代币/或者公链币
  late CurrencyInfo bigCurrency; //币种
  late num feeAmount;
  Timer? validateTimer;
  Timer? amountTimer;
  // 币种定时器
  Timer? biometricTimer;
  bool? isValidate;
  List<NetworkItem>? networkList;
  int networkIndex = 0;
  bool isPasswordSet = false;
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  HdSendState clone() {
    return HdSendState()
          ..addressController = addressController
          ..feeAmount = feeAmount
          ..currencyInfo = currencyInfo
          ..bigCurrency = bigCurrency
          ..amountController = amountController
          ..validateTimer = validateTimer
          ..amountTimer = amountTimer
          ..biometricTimer = amountTimer
          ..isValidate = isValidate
          ..networkIndex = networkIndex
          ..networkList = networkList
          ..languageResource = languageResource
          ..languageLocale = languageLocale
          ..isPasswordSet = isPasswordSet
        // ..hdWallet = hdWallet
        ;
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

HdSendState initState(Map<String, dynamic>? args) {
  CurrencyInfo bigCurrency = args!['currencyInfo'];
  CurrencyInfo currencyInfo = bigCurrency.networkLists![0];
  if (bigCurrency.networkLists != null &&
      bigCurrency.networkLists!.length == 1) {
    currencyInfo.balance = bigCurrency.balance;
  }
  bool isPasswordSet = args['isPasswordSet'];

  return HdSendState()
        ..bigCurrency = bigCurrency
        ..currencyInfo = bigCurrency.networkLists![0]
        ..feeAmount = 0
        ..isPasswordSet = isPasswordSet
      // ..hdWallet = hdWallet
      ;
}
