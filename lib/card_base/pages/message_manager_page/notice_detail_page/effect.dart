
import 'package:card_coin/card_base/pages/main_page/action.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../bean/notice_message_bean.dart';
import 'action.dart';
import 'state.dart';

Effect<NoticeDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<NoticeDetailState>>{
    Lifecycle.initState: _onInit,
    NoticeDetailAction.loadData: _onInit,
  });
}

Future<void> _onInit(Action action, Context<NoticeDetailState> ctx) async {
  Map<String, dynamic> params = {'id': ctx.state.noticeId, };
  var result =
      await HttpManager.getInstance().get(NetworkAddress.messageDetailUrl, queryParameters: params);
  if (result.isSuccess) {
    var noticeDetail = NoticeDetail.fromJson(result.data);
    ctx.dispatch(NoticeDetailActionCreator.onLoadSuccess(noticeDetail));
    ctx.broadcast(MainActionCreator.onLoadUnreadCount());
  } else {
    ctx.dispatch(NoticeDetailActionCreator.onLoadFailure(result.message));
  }
}
