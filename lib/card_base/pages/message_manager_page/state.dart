
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/notice_message_bean.dart';

class MessageManagerState extends LoadPageState<MessageManagerState> {
  late List<NoticeMessage> list;
  bool isEdit = false;
  bool isAllSelected = false;
  late RefreshController refreshController;
  int currentPage = 1;

  @override
  MessageManagerState clone() {
    return MessageManagerState()
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..currentPage = currentPage
      ..refreshController = refreshController
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..isEdit = isEdit
      ..isAllSelected = isAllSelected
      ..list = list;
  }
}

MessageManagerState initState(Map<String, dynamic>? args) {
  return MessageManagerState()
    ..loadStatus = LoadType.loading
    ..refreshController = RefreshController()
    ..list = [];
}
