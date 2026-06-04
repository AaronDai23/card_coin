
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:flutter/material.dart';

import '../../../../../global_store/state.dart';
import '../../../../bean/link_bean.dart';

class EditCardState implements GlobalBaseState<EditCardState> {
  late TextEditingController nameController;
  late NFCCardItem cardInfo;
  @override
  EditCardState clone() {
    return EditCardState()
      ..cardInfo = cardInfo
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..nameController = nameController;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

EditCardState initState(Map<String, dynamic>? args) {
  NFCCardItem cardInfo = args!['cardInfo'];
  return EditCardState()
  ..cardInfo = cardInfo
    ..nameController = TextEditingController(text: cardInfo.deviceName);
}
