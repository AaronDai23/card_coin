import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/cupertino.dart';

class CancelPinCodeState implements GlobalBaseState<CancelPinCodeState> {
  late TextEditingController pinCodeController = TextEditingController();
  late TextEditingController pukCodeController = TextEditingController();
  String cardId = '';
  @override
  CancelPinCodeState clone() {
    return CancelPinCodeState()
      ..pinCodeController = pinCodeController
      ..cardId = cardId
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..pukCodeController = pukCodeController;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CancelPinCodeState initState(Map<String, dynamic>? args) {
  return CancelPinCodeState()..cardId = args!['cardId'];
}
