
import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabWebviewState extends LoadPageState<TabWebviewState> {
  double progress = 0.0;
  bool showProgress = false;
  WebViewController? controller;
  bool canGoback = false;
  bool canGoforward = false;
  late UserInfo userInfo;
  late PageCategoryItem categoryItem;
  List<String> urlList = [];
  List<String> blackList = [];
  int unReadCount = 0;
  ProgressDialog? pr;
  @override
  TabWebviewState clone() {
    return TabWebviewState()
      ..progress = progress
      ..showProgress = showProgress
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..urlList = urlList
      ..pr = pr
      ..canGoback = canGoback
      ..canGoforward = canGoforward
      ..blackList = blackList
      ..categoryItem = categoryItem
      ..userInfo = userInfo
      ..unReadCount = unReadCount
      ..controller = controller;
  }
}

TabWebviewState initState(Map<String, dynamic>? args) {
  PageCategoryItem categoryItem = args!['categoryItem'];
  int? unReadCount = args['unReadCount'];
  UserInfo userInfo = LocalStorage.getCacheUserInfo()!;
  return TabWebviewState()
    ..userInfo = userInfo
    ..unReadCount = unReadCount ?? 0
    ..categoryItem = categoryItem;
}

