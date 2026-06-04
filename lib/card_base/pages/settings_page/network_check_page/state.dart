import 'dart:async';
import 'dart:ui';

import 'package:card_coin/card_base/bean/diagnostic_bean.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

class NetworkCheckState implements GlobalBaseState<NetworkCheckState> {
  List<DiagnosticItemResult> resultList = [];
  StreamSubscription? pingListener;
  @override
  NetworkCheckState clone() {
    return NetworkCheckState()
      ..resultList = resultList
      ..pingListener = pingListener
      ..languageResource = languageResource
      ..languageLocale = languageLocale
    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

NetworkCheckState initState(Map<String, dynamic>? args) {
  return NetworkCheckState()
  ;
}
