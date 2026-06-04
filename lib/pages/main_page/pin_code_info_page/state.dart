import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/utils/runnable/bean/pin_code_info.dart';

class PinCodeInfoState implements GlobalBaseState<PinCodeInfoState> {
  late PinCodeInfo pinCodeInfo;
  String cardId = "";
  @override
  PinCodeInfoState clone() {
    return PinCodeInfoState()
      ..pinCodeInfo = pinCodeInfo
      ..languageResource = languageResource
      ..cardId = cardId
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

PinCodeInfoState initState(Map<String, dynamic>? args) {
  return PinCodeInfoState()
    ..pinCodeInfo = args!['pinCodeInfo']
    ..cardId = args['cardId'];
}
