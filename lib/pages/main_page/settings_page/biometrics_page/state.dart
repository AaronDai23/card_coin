import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class BiometricsState implements GlobalBaseState<BiometricsState>, PageLoad {
  @override
  BiometricsState clone() {
    return BiometricsState()
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..isBiometricEnabled = isBiometricEnabled
      ..publicKey = publicKey
      ..loadStatus = loadStatus;
  }

  @override
  String errorMsg = '';

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;

  bool isBiometricEnabled = false;

  String publicKey = "";
}

BiometricsState initState(Map<String, dynamic>? args) {
  return BiometricsState();
}
