import 'dart:async';
import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:flutter/material.dart';

class ResetCardDialogState implements GlobalBaseState<ResetCardDialogState> {
  int count = 10;
  bool scanned = false;
  Timer? timer;
  Completer<ScanResponse>? completer;
  late String cardId;
  String cardNo = "";
  late bool isPinSet;
  late bool showPwdInput;
  late bool isNeedPwd = false;
  // late TextEditingController pwdController;
  String pwdText = "";

  @override
  ResetCardDialogState clone() {
    return ResetCardDialogState()
      ..count = count
      ..timer = timer
      ..completer = completer
      ..cardId = cardId
      ..cardNo = cardNo
      ..pwdText = pwdText
      ..scanned = scanned
      ..isPinSet = isPinSet
      ..isNeedPwd = isNeedPwd
      ..showPwdInput = showPwdInput
      // ..pwdController = pwdController
      ..languageResource = languageResource
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

ResetCardDialogState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  bool isPinSet = args['isPinSet'] ?? false;
  String? pwd = args['pwd'] ?? '';
  String cardNo = args['cardNo'] ?? '';
  return ResetCardDialogState()
    ..cardId = cardId
    ..isPinSet = isPinSet
    ..showPwdInput = isPinSet
    ..isNeedPwd = isPinSet
    ..pwdText = pwd!
    ..cardNo = cardNo
    // ..pwdController = TextEditingController()
    ..languageResource = args['languageResource'];
}
