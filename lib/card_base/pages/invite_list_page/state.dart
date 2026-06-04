
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/invite_bean.dart';

class InviteListState extends LoadPageState<InviteListState> {
  late List<InviteUser> list;
  late RefreshController refreshController;
  int currentPage = 1;
  @override
  InviteListState clone() {
    return InviteListState()
      ..list = list
      ..languageLocale = languageLocale
      ..refreshController = refreshController
      ..currentPage = currentPage
      ..languageResource = languageResource
      ..loadStatus = loadStatus..errorMsg = errorMsg;
  }
}

InviteListState initState(Map<String, dynamic>? args) {
  return InviteListState()
    ..refreshController = RefreshController()
    ..list = [];
}
