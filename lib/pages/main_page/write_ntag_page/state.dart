import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

class WriteNtagState implements GlobalBaseState<WriteNtagState>, PageLoad {
  /// From MyCard `smartCardConfig.ndefDomain`.
  String domainUrl = '';

  /// From MyCard `smartCardConfig.ndefAAR` (comma-separated packages).
  String ndefAAR = '';

  /// Filled after NFC scan from the physical tag UID.
  String scannedUid = '';

  /// Built after scan: domain + uid Base64.
  String fullNdefUrl = '';

  bool lockAfterWrite = true;
  bool isScanning = false;
  String statusMessage = '';

  @override
  WriteNtagState clone() {
    return WriteNtagState()
      ..domainUrl = domainUrl
      ..ndefAAR = ndefAAR
      ..scannedUid = scannedUid
      ..fullNdefUrl = fullNdefUrl
      ..lockAfterWrite = lockAfterWrite
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
    ..lockAfterWrite = true
    ..isScanning = false
    ..statusMessage = ''
    ..loadStatus = LoadType.loading;
}
