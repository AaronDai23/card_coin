import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../bean/card_info_bean.dart';
import '../../../../../../../widget/base_page_loading.dart';
import '../../../../../../bean/card_group_bean.dart';

final Map<String, List<SmartCardDetail>> _cachedGroupCardLists = {};

List<SmartCardDetail>? getCachedGroupCardList(String groupId) =>
    _cachedGroupCardLists[groupId];

void cacheGroupCardList(String groupId, List<SmartCardDetail> list) {
  _cachedGroupCardLists[groupId] = list;
}

class GroupCardDetailState extends LoadPageState<GroupCardDetailState> {
  late CardGroup cardGroup;
  SmartCardListInfo? smartCardListInfo;

  RefreshController refreshController = RefreshController();

  InvestmentSelectInfo? investmentSelectInfo;

  int currentPage = 1;
  List<SmartCardDetail> smartCardItemList = [];
  bool isFirstLoading = true;

  @override
  GroupCardDetailState clone() {
    return GroupCardDetailState()
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..smartCardListInfo = smartCardListInfo
      ..smartCardItemList = smartCardItemList
      ..cardGroup = cardGroup
      ..currentPage = currentPage
      ..investmentSelectInfo = investmentSelectInfo
      ..refreshController = refreshController;
  }
}

GroupCardDetailState initState(Map<String, dynamic>? args) {
  CardGroup cardGroup = args!['cardGroup'];
  final cachedList = getCachedGroupCardList(cardGroup.groupId ?? '');
  return GroupCardDetailState()
    ..loadStatus = LoadType.loadSuccess
    ..cardGroup = cardGroup
    ..smartCardItemList = cachedList ?? []
    ..isFirstLoading = cachedList == null;
}
