

import '../../../../widget/base_page_loading.dart';
import '../../../bean/notice_message_bean.dart';

class NoticeDetailState extends LoadPageState<NoticeDetailState>  {

  late String noticeId;
  NoticeDetail? noticeDetail;

  @override
  NoticeDetailState clone() {
    return NoticeDetailState()
      ..noticeId = noticeId
      ..languageLocale = languageLocale
      ..noticeDetail = noticeDetail
      ..errorMsg = errorMsg
      ..languageResource = languageResource
      ..loadStatus = loadStatus
    ;
  }
}

NoticeDetailState initState(Map<String, dynamic>? args) {
  String noticeId = args!['noticeId'];
  return NoticeDetailState()
    ..loadStatus = LoadType.loading
    ..noticeId = noticeId;
}
