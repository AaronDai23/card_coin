import 'dart:ui';

import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../global_store/state.dart';
import '../../../../../../widget/base_page_loading.dart';
import 'adapter/state.dart';

final Map<String, List<CardGroupItemState>> _cachedGroupCardLists = {};
const String _groupCardListCachePrefix = 'group_card_list_v1_';

List<CardGroupItemState>? getCachedGroupCardList(String cacheKey) =>
    _cachedGroupCardLists[cacheKey];

void cacheGroupCardList(String cacheKey, List<CardGroupItemState> list) {
  _cachedGroupCardLists[cacheKey] = list;
}

String groupCardListCacheKey(String cacheKey) =>
    '$_groupCardListCachePrefix$cacheKey';

class GroupCardState extends BasePageState<CardGroupItemState>
    implements GlobalBaseState<GroupCardState> {
  late RefreshController refreshController;
  int currentPage = 1;
  int unReadCount = 0;
  bool isFirstLoading = true;
  @override
  GroupCardState clone() {
    return GroupCardState()
      ..errorMsg = errorMsg
      ..list = list
      ..currentPage = currentPage
      ..refreshController = refreshController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..unReadCount = unReadCount
      ..loadStatus = loadStatus
      ..isFirstLoading = isFirstLoading;
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

GroupCardState initState(Map<String, dynamic>? args) {
  final cacheKey = (args?['cacheKey'] ?? 'default').toString();
  final cachedList = getCachedGroupCardList(cacheKey);
  return GroupCardState()
    ..refreshController = RefreshController()
    ..list = cachedList ?? []
    ..isFirstLoading = cachedList == null
    ..loadStatus = LoadType.loadSuccess;
}
