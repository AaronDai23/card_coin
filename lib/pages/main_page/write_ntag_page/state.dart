import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

class WriteNtagState implements GlobalBaseState<WriteNtagState>, PageLoad {
  String domainUrl = '';
  String ndefAAR = '';
  String scannedUid = '';
  String fullNdefUrl = '';
  String chipModel = '';

  /// Password write-protect (reversible). Not permanent writeLock.
  bool passwordProtect = true;
  bool isScanning = false;
  String statusMessage = '';

  @override
  WriteNtagState clone() {
    return WriteNtagState()
      ..domainUrl = domainUrl
      ..ndefAAR = ndefAAR
      ..scannedUid = scannedUid
      ..fullNdefUrl = fullNdefUrl
      ..chipModel = chipModel
      ..passwordProtect = passwordProtect
      ..isScanning = isScanning
      ..statusMessage = statusMessage
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource;
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

WriteNtagState initState(Map<String, dynamic>? args) {
  return WriteNtagState()
    ..passwordProtect = true
    ..isScanning = false
    ..statusMessage = ''
    ..loadStatus = LoadType.loading;
}
