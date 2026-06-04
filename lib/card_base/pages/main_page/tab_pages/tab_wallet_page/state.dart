import 'package:flutter/material.dart';

import '../../../../../widget/base_page_loading.dart';
import '../../../../bean/banner_bean.dart';
import '../../../../bean/page_categroy_item.dart';
import '../../../../bean/post_card_info.dart';

class TabWalletState extends LoadPageState<TabWalletState> {
  int total = 0;
  int currentIndex = 0;
  late String title;
  late TabController tabController;
  List<BannerItem>? banners;

  Color? bgColor = Colors.white;

  int unReadCount = 0;
  bool enableNfcCreate = false;
  List<CardCreateType>? typeList;
  String? taskItemId;
  @override
  TabWalletState clone() {
    return TabWalletState()
      ..currentIndex = currentIndex
      ..total = total
      ..title = title
      ..banners = banners
      ..unReadCount = unReadCount
      ..typeList = typeList
      ..enableNfcCreate = enableNfcCreate
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..bgColor = bgColor
      ..errorMsg = errorMsg
      ..taskItemId = taskItemId
      ..loadStatus = loadStatus;
  }
}

List<BannerItem> buildFallbackWalletBanners() {
  return [
    BannerItem(
      fileUrl: 'tap_banner_bg2',
      name: 'Cards',
      type: 'NONE',
    ),
  ];
}

TabWalletState initState(Map<String, dynamic>? args) {
  PageCategoryItem? categoryItem = args?['categoryItem'];
  int? unReadCount = args?['unReadCount'];
  String? taskItemId = args?['taskItemId'];
  return TabWalletState()
    ..unReadCount = unReadCount ?? 0
    ..taskItemId = taskItemId
    ..banners = buildFallbackWalletBanners()
    ..loadStatus = LoadType.loadSuccess
    ..title = categoryItem?.name ?? 'Cards';
}
