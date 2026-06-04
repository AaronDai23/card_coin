import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/cupertino.dart';

class UnlockPinCodeState implements GlobalBaseState<UnlockPinCodeState> {
  late TextEditingController pinCodeController = TextEditingController();
  late TextEditingController pukCodeController = TextEditingController();
  String cardId = "";

  @override
  UnlockPinCodeState clone() {
    return UnlockPinCodeState()
      ..pinCodeController = pinCodeController
      ..pukCodeController = pukCodeController
      ..languageResource = languageResource
      ..cardId = cardId
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

UnlockPinCodeState initState(Map<String, dynamic>? args) {
  return UnlockPinCodeState()..cardId = args!["cardId"];
}
