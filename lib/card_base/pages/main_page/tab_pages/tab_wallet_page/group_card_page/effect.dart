import 'dart:convert';

import 'package:card_coin/card_base/pages/main_page/action.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../../../../common/common_action/action.dart';
import '../../../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../../../http/http_manager.dart';
import '../../../../../../widget/custom_alert_dialog.dart';
import '../../../../../bean/card_group_bean.dart';
import '../../../../../bean/card_member_bean.dart';
import '../../../../edit_member_page/action.dart';
import '../my_card_page/action.dart';
import 'action.dart';
import 'adapter/state.dart';

import 'group_card_detail_page/action.dart';
import 'member_item_component/action.dart';
import 'state.dart';

const String pageSize = '20';

Effect<GroupCardState>? buildEffect() {
  return combineEffects(<Object, Effect<GroupCardState>>{
    Lifecycle.initState: _onInit,
    MyCardAction.refreshHoldCard: _onRefreshHoldCard,
    GroupCardDetailAction.refreshHoldCard: _onRefreshHoldCard,
    CommonAction.languageChanged: _onInit,
    MemberItemAction.editClick: _onEditClick,
    EditMemberAction.updateCardInfo: _onInit,
    GroupCardAction.loadData: _onLoadData,
    MainAction.updateUnReadCount: _onUpdateUnReadCount,
  });
}

void _onInit(Action action, Context<GroupCardState> ctx) {
  _restoreCachedGroupList(ctx);
  ctx.dispatch(GroupCardActionCreator.onLoadData());
}

Future<void> _onUpdateUnReadCount(
    Action action, Context<GroupCardState> ctx) async {
  ctx.dispatch(GroupCardActionCreator.onUpdateUnReadCount(action.payload));
}

void _onRefreshHoldCard(Action action, Context<GroupCardState> ctx) {
  ctx.state.currentPage = 1;
  ctx.dispatch(GroupCardActionCreator.onLoadData());
}

void _onLoadData(Action action, Context<GroupCardState> ctx) {
  bool isLoadMore = action.payload;
  int currentPage = ctx.state.currentPage;
  Map<String, dynamic> params = {
    'page': isLoadMore ? currentPage + 1 : currentPage,
    'rows': pageSize
  };
  HttpManager.getInstance()
      .get(NetworkAddress.cardGroupsUrl, queryParameters: params)
      .then((result) {
    if (result.isSuccess) {
      if (isLoadMore) {
        ctx.state.currentPage++;
      }
      var groupList = CardGroupListInfo.fromJson(result.data);
      if (ctx.state.currentPage * int.parse(pageSize) >= groupList.total!) {
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
      _cacheGroupList(ctx, groupList);
      ctx.dispatch(GroupCardActionCreator.onLoadSuccess(groupList));
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadFailed();
      } else {
        ctx.state.refreshController.refreshFailed();
      }
      ctx.dispatch(GroupCardActionCreator.onLoadFailure(result.message));
    }
  });
}

void _restoreCachedGroupList(Context<GroupCardState> ctx) {
  const cacheKey = 'default';
  final localCacheKey = groupCardListCacheKey(cacheKey);
  LocalStorage.getString(localCacheKey).then((value) {
    if (value == null || value.isEmpty) {
      return;
    }
    try {
      final groupList = CardGroupListInfo.fromJson(
          Map<String, dynamic>.from(json.decode(value) as Map));
      final list =
          groupList.list?.map((e) => initCardGroupItemState(e)).toList();
      if (list != null && list.isNotEmpty) {
        cacheGroupCardList(cacheKey, list);
        ctx.dispatch(GroupCardActionCreator.onLoadSuccess(groupList));
      }
    } catch (_) {}
  });
}

void _cacheGroupList(Context<GroupCardState> ctx, CardGroupListInfo groupList) {
  const cacheKey = 'default';
  try {
    LocalStorage.saveString(
        groupCardListCacheKey(cacheKey), json.encode(groupList.toJson()));
  } catch (_) {}
  final list = groupList.list?.map((e) => initCardGroupItemState(e)).toList();
  if (list != null) {
    cacheGroupCardList(cacheKey, list);
  }
}

Future<void> _onEditClick(Action action, Context<GroupCardState> ctx) async {
  MemberCardItem cardItem = action.payload;
  String? result = await showDialog<String?>(
      context: ctx.context,
      builder: (context) {
        return ZenggeInputAlertDialog(
          titleText: ctx.state.languageResource!.editRemark,
          enableCancel: true,
          initText: cardItem.nickName ?? '',
        );
      });

  if (result != null) {
    Map<String, dynamic> params = {'id': cardItem.id, 'nickName': result};
    ProgressDialog pr = ProgressDialog(ctx.context);
    await pr.show();
    var updateResult = await HttpManager.getInstance()
        .post(NetworkAddress.updateMemberRemarkUrl, null, data: params);
    pr.hide();
    if (updateResult.isSuccess) {
      ctx.dispatch(GroupCardActionCreator.onUpdateRemark(cardItem.id!, result));
    } else {
      showToast(updateResult.message);
    }
  }
}
