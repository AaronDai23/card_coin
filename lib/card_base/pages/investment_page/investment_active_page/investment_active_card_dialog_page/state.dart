import 'dart:async';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

class InvestmentActiveCardDialogState
    implements GlobalBaseState<InvestmentActiveCardDialogState> {
  int count = 5;
  int currentCount = 0;
  bool scanned = false;
  Timer? timer;
  Completer<ScanResponse>? completer;
  late String cardId;
  late bool isPinSet;
  late bool showPwdInput;
  late bool isNeedPwd = false;
  late TextEditingController pwdController;
  List<CurrencyInfo> defaultCurrencyList = [];
  @override
  InvestmentActiveCardDialogState clone() {
    return InvestmentActiveCardDialogState()
      ..count = count
      ..timer = timer
      ..completer = completer
      ..cardId = cardId
      ..scanned = scanned
      ..isPinSet = isPinSet
      ..isNeedPwd = isNeedPwd
      ..showPwdInput = showPwdInput
      ..pwdController = pwdController
      ..languageResource = languageResource
      ..defaultCurrencyList = defaultCurrencyList
      ..currentCount = currentCount
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

InvestmentActiveCardDialogState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  bool isPinSet = args['isPinSet'] ?? false;
  List<CurrencyInfo> defaultCurrencyList = args['defaultCurrencyList'] ?? [];
  return InvestmentActiveCardDialogState()
    ..cardId = cardId
    ..isPinSet = isPinSet
    ..showPwdInput = isPinSet
    ..isNeedPwd = isPinSet
    ..pwdController = TextEditingController()
    ..defaultCurrencyList = defaultCurrencyList
    ..languageResource = args['languageResource'];
}
