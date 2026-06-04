import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/runnable/bean/pin_code_info.dart';

class SetPinCodeState implements GlobalBaseState<SetPinCodeState> {
  late PinCodeInfo pinCodeInfo;
  late TextEditingController pinCodeController = TextEditingController();
  late TextEditingController newPinCodeController = TextEditingController();
  String cardId = "";
  @override
  SetPinCodeState clone() {
    return SetPinCodeState()
      ..pinCodeController = pinCodeController
      ..newPinCodeController = newPinCodeController
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

SetPinCodeState initState(Map<String, dynamic>? args) {
  PinCodeInfo pinCodeInfo = args!['pinCodeInfo'];
  return SetPinCodeState()
    ..pinCodeInfo = pinCodeInfo
    ..cardId = args['cardId'];
}
