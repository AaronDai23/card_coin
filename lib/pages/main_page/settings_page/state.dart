import 'dart:ui';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';

import '../../../global_store/state.dart';

class SettingsState implements GlobalBaseState<SettingsState> {
  String cardId = "";
  late CardInfo cardInfo;

  List<PageCategoryItem> list = [];
  @override
  SettingsState clone() {
    return SettingsState()
      ..cardId = cardId
      ..list = list
      ..cardInfo = cardInfo
      ..languageResource = languageResource
      ..languageLocale = languageLocale;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  String errorMsg = '';

  LoadType loadStatus = LoadType.loadSuccess;
}

SettingsState initState(Map<String, dynamic>? args) {
  var cardId = args!['cardId'];
  var cardInfo = args['cardInfo'];
  return SettingsState()
    ..cardId = cardId
    ..cardInfo = cardInfo;
}
