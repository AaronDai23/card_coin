import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

import '../../../bean/health_check_bean.dart';

class ResetInfoState implements GlobalBaseState<ResetInfoState> {
  late CardHealthCommonStatus cardInfo;
  late String cardNo;

  @override
  ResetInfoState clone() {
    return ResetInfoState()
      ..cardInfo = cardInfo
      ..languageLocale = languageLocale
      ..cardNo = cardNo
      ..languageResource = languageResource;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

ResetInfoState initState(Map<String, dynamic>? args) {
  assert(args?['cardInfo'] != null, 'No cardInfo.');
  CardHealthCommonStatus cardInfo = args!['cardInfo'];
  String cardNo = args['cardNo'] ?? '';
  return ResetInfoState()
    ..cardInfo = cardInfo
    ..cardNo = cardNo;
}
