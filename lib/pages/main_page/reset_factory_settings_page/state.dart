import 'dart:async';
import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/utils/scan_util.dart';

class ResetFactorySettingsState
    implements GlobalBaseState<ResetFactorySettingsState> {
  bool check = false;
  late bool isPinSet;
  late String cardId;
  String cardNo = "";
  String pwd = "";
  int count = 10;
  bool scanned = false;
  Timer? timer;
  Completer<ScanResponse>? completer;

  @override
  ResetFactorySettingsState clone() {
    return ResetFactorySettingsState()
      ..cardId = cardId
      ..isPinSet = isPinSet
      ..check = check
      ..pwd = pwd
      ..count = count
      ..cardNo = cardNo
      ..timer = timer
      ..completer = completer
      ..scanned = scanned
      ..languageResource = languageResource
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

ResetFactorySettingsState initState(Map<String, dynamic>? args) {
  return ResetFactorySettingsState()
    ..cardId = args!['cardId']
    ..cardNo = args!['cardNo'] ?? ''
    ..isPinSet = args['isPinSet'];
}
