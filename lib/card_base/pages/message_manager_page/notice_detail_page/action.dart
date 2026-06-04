
import 'package:fish_redux/fish_redux.dart';

import '../../../bean/notice_message_bean.dart';

//TODO replace with your own action
enum NoticeDetailAction { loadSuccess,loadFailure,showLoading,loadData}

class NoticeDetailActionCreator {


  static Action onLoadSuccess(NoticeDetail noticeDetail) {
    return Action(NoticeDetailAction.loadSuccess,payload: noticeDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(NoticeDetailAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(NoticeDetailAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(NoticeDetailAction.loadData);
  }
}
