import 'dart:async';
import 'dart:ui';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/utils/scan_util.dart';

class DeviceSettingsState implements GlobalBaseState<DeviceSettingsState> {
  Completer<ScanResponse>? completer;

  String cardId = "";
  late CardDetail cardDetail;
  CardInfo? cardInfo;
  @override
  DeviceSettingsState clone() {
    return DeviceSettingsState()
      ..completer = completer
      ..languageResource = languageResource
      ..cardId = cardId
      ..cardInfo = cardInfo
      ..cardDetail = cardDetail
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

DeviceSettingsState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  CardInfo cardInfo = args['cardInfo'];
  return DeviceSettingsState()
    ..cardId = cardId
    ..cardDetail = cardInfo.cardDetail!;
}
