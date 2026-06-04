import 'dart:convert';

import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/pages/investment_page/action.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/group_card_page/group_card_detail_page/widgets/smart_detail_view.dart';
import 'package:card_coin/http/address.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import '../../../../../../../cache/local_storage.dart';
import '../../../../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../../../../http/http_manager.dart';
import '../../../../../../../pigeons/blockchain_platform_interface.dart';
import '../../../../../../../widget/custom_alert_dialog.dart';
import '../../../../../../bean/card_group_bean.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';

Effect<GroupCardDetailState>? buildEffect() {
  return combineEffects(<Object, Effect<GroupCardDetailState>>{
    Lifecycle.initState: _onInit,
    GroupCardDetailAction.loadData: _onLoadData,
    GroupCardDetailAction.showDeleteDialog: _onShowDeleteDialog,
    GroupCardDetailAction.showDetailDialog: _onShowDetailDialog,
    GroupCardDetailAction.itemClick: _onItemClick,
    GroupCardDetailAction.pushInvestmentActvite: _onActiveClick,
    GroupCardDetailAction.investmentlist: _onInvestmentClick,
    InvestmentAction.activitedSucCard: _onLoadData1,
  });
}

Future<void> _onInit(Action action, Context<GroupCardDetailState> ctx) async {
  ctx.dispatch(GroupCardDetailActionCreator.onLoadData());
}

Future<void> _onLoadData1(
    Action action, Context<GroupCardDetailState> ctx) async {
  print("_onLoadData1");
  ctx.dispatch(GroupCardDetailActionCreator.onLoadData(isLoadMore: false));
}

Future<void> _onItemClick(
    Action action, Context<GroupCardDetailState> ctx) async {
  String cardId = action.payload;

  ///获取卡片信息缓存
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardId);
  if (cardInfoJson?.isNotEmpty ?? false) {
    ///根据设备uuid初始化scanResponse,如果失败代表没有本地没有扫卡缓存数据，需要重新扫卡
    var success = await BlockchainPlatform.instance.initScanResponse(cardId);
    if (success) {
      var cardInfo = CardInfo.fromJson(json.decode(cardInfoJson!));
      Navigator.of(ctx.context)
          .pushNamed('cardWalletListPage', arguments: {'cardInfo': cardInfo});
      return;
    }
  }
  Navigator.of(ctx.context)
      .pushNamed('scanWalletPage', arguments: {'cardId': cardId});
}

Future<void> _onShowDetailDialog(
    Action action, Context<GroupCardDetailState> ctx) async {
  SmartCardDetail cardDetail = action.payload;
  showDialog(
      context: ctx.context,
      builder: (context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          semanticLabel: '',
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            color: Colors.white,
            child: SmartDetailView(cardDetail),
          ),
          actions: [
            SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK')))
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(vertical: 10.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
        );
      });
}

Future<void> _onShowDeleteDialog(
    Action action, Context<GroupCardDetailState> ctx) async {
  var languageResource = ctx.state.languageResource!;
  var result = await showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(
          languageResource.confirmDelete,
          enableCancel: true,
        );
      });
  if (result != null && result) {
    ProgressDialog pr = ProgressDialog(ctx.context);
    await pr.show();
    SmartCardDetail cardInfo = action.payload;
    var deleteResult = await HttpManager.getInstance().post(
        NetworkAddress.deleteSmartCardUrl, null,
        data: jsonEncode([cardInfo.customerSmartCardId]));
    pr.hide();
    if (deleteResult.isSuccess) {
      if (deleteResult.data) {
        ctx.broadcast(GroupCardDetailActionCreator.onDeletedUpateCardDetail(
            cardInfo.uid!));
        ctx.state.refreshController.requestRefresh();
        ctx.broadcast(GroupCardDetailActionCreator.onRefreshHoldCard());
      } else {
        showToast(languageResource.operateError);
      }
    } else {
      showToast(deleteResult.message);
    }
  }
}

void _onLoadData(Action action, Context<GroupCardDetailState> ctx) {
  bool isLoadMore = action.payload;

  Map<String, dynamic> params = {
    'groupId': ctx.state.cardGroup.groupId!,
    'page': isLoadMore ? ctx.state.currentPage + 1 : 1,
    'rows': pageSize
  };
  HttpManager.getInstance()
      .get(NetworkAddress.smartCardListUrl, queryParameters: params)
      .then((result) {
    if (result.isSuccess) {
      if (isLoadMore) {
        ctx.state.currentPage++;
      } else {
        ctx.state.currentPage = 1;
      }
      var smartCardListInfo = SmartCardListInfo.fromJson(result.data);
      if (ctx.state.currentPage * int.parse(pageSize) >=
          smartCardListInfo.total!) {
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
      ctx.dispatch(GroupCardDetailActionCreator.onLoadSuccess(smartCardListInfo,
          isMore: isLoadMore));
    } else {
      if (isLoadMore) {
        ctx.state.refreshController.loadFailed();
      } else {
        ctx.state.refreshController.refreshFailed();
      }
      ctx.dispatch(GroupCardDetailActionCreator.onLoadFailure(result.message));
    }
  });
}

Future<void> _onActiveClick(
    Action action, Context<GroupCardDetailState> ctx) async {
  SmartCardDetail cardDetail = action.payload;
  final cardConfig = cardDetail.investmentConfig!.toString();
  LocalStorage.saveString(
      LocalStorage.cardInvestmentConfig + cardDetail.uid!, cardConfig);
  var reslut = await Navigator.of(ctx.context)
      .pushNamed('investmentActivePage', arguments: {
    'cardId': cardDetail.uid!,
    'id': cardDetail.investment!.id,
    // 'seletedTime': ctx.state.investmentSelectInfo != null
    //     ? ctx.state.investmentSelectInfo!.displayValue
    //     : "",
    'investmentConfig': cardDetail.investmentConfig
  });

  if (reslut != null) {
    print("investmentActivePage_reslut:$reslut");
    ctx.dispatch(GroupCardDetailActionCreator.onLoadData());
  }
}

Future<void> _onInvestmentClick(
    Action action, Context<GroupCardDetailState> ctx) async {
  SmartCardDetail cardDetail = action.payload;
  Navigator.of(ctx.context).pushNamed('investmentPage', arguments: {
    'uid': cardDetail.uid,
    'investmentConfig': cardDetail.investmentConfig
  });
}
