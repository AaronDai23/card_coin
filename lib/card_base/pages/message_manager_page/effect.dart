import 'dart:convert';

import 'package:card_coin/card_base/pages/main_page/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import '../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../../widget/custom_alert_dialog.dart';
import '../../bean/notice_message_bean.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';

Effect<MessageManagerState>? buildEffect() {
  return combineEffects(<Object, Effect<MessageManagerState>>{
    Lifecycle.initState: _onInit,
    MessageManagerAction.loadData: _onLoadData,
    MessageManagerAction.setMessagesRead: _onSetMessageRead,
    MessageManagerAction.deleteMessages: _onDeleteMessages,
    MainAction.updateUnReadCount: _onInit,
    MessageManagerAction.selectAllClick: _onSelectAllClick,
  });
}

Future<void> _onInit(Action action, Context<MessageManagerState> ctx) async {
  ctx.dispatch(MessageManagerActionCreator.onLoadData());
}

Future<void> _onLoadData(
    Action action, Context<MessageManagerState> ctx) async {
  bool isLoadMore = action.payload;

  Map<String, dynamic> params = {
    'page': isLoadMore ? ctx.state.currentPage + 1 : 1,
    'rows': pageSize
  };
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.messageListUrl, queryParameters: params);
  if (result.isSuccess) {
    if (isLoadMore) {
      ctx.state.currentPage++;
    } else {
      ctx.state.currentPage = 1;
    }

    var listInfo = MessageListInfo.fromJson(result.data);
    if (ctx.state.currentPage * int.parse(pageSize) >= listInfo.total!) {
      if (!isLoadMore) {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
      ctx.state.refreshController.loadNoData();
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.refreshCompleted(resetFooterState: true);
      }
    }
    ctx.dispatch(MessageManagerActionCreator.onLoadSuccess(listInfo,
        isMore: isLoadMore));
  } else {
    if (isLoadMore) {
      ctx.state.refreshController.loadFailed();
    } else {
      ctx.state.refreshController.refreshFailed();
    }
    ctx.dispatch(MessageManagerActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onSetMessageRead(
    Action action, Context<MessageManagerState> ctx) async {
  List<String> ids = [];
  for (var item in ctx.state.list) {
    if (item.isSelected) {
      ids.add(item.id!);
    }
  }
  if (ids.isEmpty) {
    showToast(ctx.state.languageResource!.selectMessage);
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.messageReadUrl, null, data: jsonEncode(ids));
  pr.hide();
  if (result.isSuccess) {
    ctx.state.isAllSelected = false;
    ctx.dispatch(MessageManagerActionCreator.onUpdateItemsRead(ids));
    ctx.broadcast(MainActionCreator.onLoadUnreadCount());
  } else {
    ctx.dispatch(MessageManagerActionCreator.onLoadFailure(result.message));
  }
}

Future<void> _onSelectAllClick(
    Action action, Context<MessageManagerState> ctx) async {
  List<NoticeMessage> list;
  var iterable = ctx.state.list.where((element) => element.isSelected);

  if (iterable.length == ctx.state.list.length) {
    ctx.state.isAllSelected = false;
    list = ctx.state.list.map((e) {
      e.isSelected = false;
      return e;
    }).toList();
  } else {
    ctx.state.isAllSelected = true;
    list = ctx.state.list.map((e) {
      e.isSelected = true;
      return e;
    }).toList();
  }

  ctx.dispatch(MessageManagerActionCreator.onUpdateMessageList(list));
}

Future<void> _onDeleteMessages(
    Action action, Context<MessageManagerState> ctx) async {
  List<String> ids = [];
  for (var item in ctx.state.list) {
    if (item.isSelected) {
      ids.add(item.id!);
    }
  }
  if (ids.isEmpty) {
    showToast(ctx.state.languageResource!.selectOperateMsg);
    return;
  }

  var isConfirm = await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(
          ctx.state.languageResource!.deleteMsgTip,
          enableActions: true,
          cancelText: ctx.state.languageResource!.cancel,
        );
      });

  if (isConfirm == null || isConfirm == false) {
    return;
  }

  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.messageDeleteUrl, null, data: jsonEncode(ids));
  pr.hide();
  if (result.isSuccess) {
    var list = ctx.state.list.toList();
    list.removeWhere((element) => ids.contains(element.id));
    ctx.state.isAllSelected = false;
    ctx.dispatch(MessageManagerActionCreator.onUpdateMessageList(list));
    ctx.broadcast(MainActionCreator.onLoadUnreadCount());
  } else {
    ctx.dispatch(MessageManagerActionCreator.onLoadFailure(result.message));
  }
}
