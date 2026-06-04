import 'dart:ui';

import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pages/app_version_page/bean/language_model.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChangeLanguageState implements LoadPageState<ChangeLanguageState> {
  @override
  ChangeLanguageState clone() {
    return ChangeLanguageState()
      ..refreshController = refreshController
      ..currentIndex = currentIndex
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..languageList = languageList
      ..languageLocale = languageLocale
      ..languageResource = languageResource;
  }

  @override
  Locale? languageLocale;

  RefreshController refreshController = RefreshController();

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;

  int currentIndex = 0;

  List<LanguageModel> languageList = [];
}

ChangeLanguageState initState(Map<String, dynamic>? args) {
  return ChangeLanguageState();
}
