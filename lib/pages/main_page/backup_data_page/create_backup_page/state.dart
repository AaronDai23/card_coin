import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

import '../../../../bean/card_info_bean.dart';

class CreateBackupState implements GlobalBaseState<CreateBackupState> {
  String cardData = '';
  String cardId = "";
  late CardDetail cardDetail;
  @override
  CreateBackupState clone() {
    return CreateBackupState()
      ..cardData = cardData
      ..cardDetail = cardDetail
      ..languageLocale = languageLocale
      ..cardId = cardId
      ..languageResource = languageResource;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CreateBackupState initState(Map<String, dynamic>? args) {
  assert(args?['cardData'] != null, 'cardData is empty');
  return CreateBackupState()
    ..cardData = args!['cardData']
    ..cardDetail = args['cardDetail']
    ..cardId = args['cardId'];
}
