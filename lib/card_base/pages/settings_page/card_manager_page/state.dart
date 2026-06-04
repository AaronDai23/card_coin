import 'dart:ui';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../global_store/state.dart';
import '../../../../widget/base_page_loading.dart';
import 'card_item_component/state.dart';

class CardManagerState extends BasePageState<CardItemState> implements GlobalBaseState<CardManagerState>{
  int total = 0;
  int currentIndex = 0;
  late RefreshController refreshController;
  int currentPage = 1;
  @override
  CardManagerState clone() {
    return CardManagerState()
      ..list = list
      ..currentIndex = currentIndex
      ..total = total
      ..currentPage = currentPage
      ..refreshController = refreshController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus;
  }

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

CardManagerState initState(Map<String, dynamic>? args) {
  return CardManagerState()
    ..refreshController = RefreshController()
    ..list = [];
}
