import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:flutter/material.dart';

import '../../../cache/bean/user_info_bean.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/more_menu_info.dart';
import '../../bean/page_categroy_item.dart';

class MainState extends LoadPageState<MainState> {
  UserInfo? userInfo;
  int currentIndex = 0;
  late List<PageCategoryItem> tabList;
  TabController? tabController;
  late GlobalKey showPopWinKey;

  MoreMenuInfo? menuInfo;
  int unReadCount = 0;

  Animation<double>? animation;
  AnimationController? menuController;
  TickerProvider? tickerProvider;
  String? taskItemId;

  AppsflyerSdk? appsflyerSdk;

  int selectItem = -1;

  @override
  MainState clone() {
    return MainState()
      ..userInfo = userInfo
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..tabController = tabController
      ..tabList = tabList
      ..menuInfo = menuInfo
      ..errorMsg = errorMsg
      ..menuController = menuController
      ..unReadCount = unReadCount
      ..loadStatus = loadStatus
      ..animation = animation
      ..languageLocale = languageLocale
      ..appsflyerSdk = appsflyerSdk
      ..selectItem = selectItem
      ..tickerProvider = tickerProvider
      ..taskItemId = taskItemId
      ..showPopWinKey = showPopWinKey;
  }

  bool get isLogin => userInfo != null;
}

List<PageCategoryItem> buildFallbackMainTabs() {
  return [
    PageCategoryItem(
      code: 'WALLET',
      name: 'Tap',
      status: 'ACTIVE',
      category: 'HOME',
      categoryName: 'Home',
      hiddenTab: true,
      targetName: 'Tap Card Page',
      target: 'tabWalletPage',
      type: 'ACTIVITY',
    ),
  ];
}

MainState initState(Map<String, dynamic>? args) {
  UserInfo? userInfo = LocalStorage.getCacheUserInfo();
  String? taskItemId = args?["taskItemId"];
  return MainState()
    ..tabList = buildFallbackMainTabs()
    ..loadStatus = LoadType.loadSuccess
    ..taskItemId = taskItemId
    ..showPopWinKey = GlobalKey()
    ..userInfo = userInfo;
}
