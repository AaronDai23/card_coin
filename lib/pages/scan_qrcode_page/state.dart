import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class ScanQrcodeState implements GlobalBaseState<ScanQrcodeState> {
  ScanController controller = ScanController();
  IconData lightIcon = Icons.flash_on;
  @override
  ScanQrcodeState clone() {
    return ScanQrcodeState()
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..controller = controller
      ..lightIcon = lightIcon
      ..languageResource = languageResource
      ..languageLocale = languageLocale
    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

ScanQrcodeState initState(Map<String, dynamic>? args) {
  return ScanQrcodeState();
}
