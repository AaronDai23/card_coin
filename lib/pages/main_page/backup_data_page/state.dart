import 'dart:ui';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

class BackupDataState implements GlobalBaseState<BackupDataState> {
  String cardId = "";
  late CardDetail cardDetail;
  @override
  BackupDataState clone() {
    return BackupDataState()
      ..languageLocale = languageLocale
      ..cardId = cardId
      ..cardDetail = cardDetail
      ..languageResource = languageResource;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

BackupDataState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  CardDetail cardDetail = args['cardDetail'];
  return BackupDataState()
    ..cardId = cardId
    ..cardDetail = cardDetail
  ;
}
