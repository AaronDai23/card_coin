import 'package:card_coin/card_base/bean/card_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../generated/l10n.dart';
import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../widget/custom_alert_dialog.dart';
import '../../../bean/link_bean.dart';
import '../../../utils/card_util.dart';
import 'action.dart';
import 'card_item_component/action.dart';
import 'edit_card_page/action.dart';
import 'state.dart';

const String pageSize = '20';

Effect<CardManagerState>? buildEffect() {
  return combineEffects(<Object, Effect<CardManagerState>>{
    CardManagerAction.loadData: _onLoadData,
    Lifecycle.initState: _onInit,
    CardItemAction.itemClick: _onItemClick,
    CardItemAction.deleteClick: _onDeleteClick,
    EditCardAction.updateCardInfo: _onUpdateCardInfo,
    CardManagerAction.addCardClick: _onAddCardClick,

  });
}

void _onInit(Action action, Context<CardManagerState> ctx) {
  ctx.dispatch(CardManagerActionCreator.onLoadData());
}

void _onItemClick(Action action, Context<CardManagerState> ctx) {
  Navigator.of(ctx.context).pushNamed('editCardPage',arguments: {'cardInfo': action.payload});
}

Future<void> _onDeleteClick(Action action, Context<CardManagerState> ctx) async {
  var result = await showDialog(context: ctx.context, builder: (context){
    return ZenggeTextAlertDialog(S.current.confirmDelete,enableCancel: true,);
  });

  if(result != null&& result){
    NFCCardItem cardItem = action.payload;
    Map<String, dynamic> params = {'id':cardItem.id};
    ProgressDialog pr = ProgressDialog(ctx.context);
    await pr.show();
    var deleteResult = await HttpManager.getInstance().post(NetworkAddress.deleteCardUrl,null,data: params);
    pr.hide();
    if(deleteResult.isSuccess){
      ctx.dispatch(CardManagerActionCreator.onDeleteItem(cardItem.id??''));
      ctx.broadcast(CardManagerActionCreator.onDeleteItem(cardItem.id??''));
    }else{
      showToast(deleteResult.message);
    }
  }

}

void _onUpdateCardInfo(Action action, Context<CardManagerState> ctx) {
  ctx.dispatch(CardManagerActionCreator.onLoadData());
}

void _onLoadData(Action action, Context<CardManagerState> ctx) {
  bool isLoadMore = action.payload;
  int currentPage = ctx.state.currentPage;

  Map<String, dynamic> params = {
    'page': isLoadMore ? currentPage + 1 : currentPage,
    'rows': pageSize
  };
  HttpManager.getInstance().get(NetworkAddress.cardListUrl, queryParameters: params).then((result) {
    if (result.isSuccess) {
      if (isLoadMore) {
        ctx.state.currentPage++;
      }
      CardListInfo cardListInfo = CardListInfo.fromJson(result.data);
      if (ctx.state.currentPage * int.parse(pageSize) >= cardListInfo.total!) {
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
      ctx.dispatch(CardManagerActionCreator.onLoadSuccess(cardListInfo));
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadFailed();
      } else {
        ctx.state.refreshController.refreshFailed();
      }
      ctx.dispatch(CardManagerActionCreator.onLoadFailure(result.message));
    }
  });
}




Future<void> _onAddCardClick(Action action, Context<CardManagerState> ctx) async {
  BaseCardInfo? cardInfo = await CardUtil.scanPostCard(ctx.context);
  if(cardInfo == null){
    return;
  }

  Navigator.of(ctx.context).pushNamed('addCardPage',arguments: {
    'cardId':cardInfo.identifier,'cardInfo':cardInfo
  });

}
