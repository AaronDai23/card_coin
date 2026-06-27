import 'dart:convert';

import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/bean/coin_message_detail.dart';
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/bean/page_field_config.dart';
import 'package:card_coin/bean/page_field_config_info.dart';
import 'package:card_coin/bean/sales_data.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/dapp_info.dart';
import 'package:card_coin/card_base/pages/investment_page/action.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_process_page/action.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/action.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/group_card_page/group_card_detail_page/action.dart';
import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/custom_widget/progress_dialog/progress_dialog.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:card_coin/utils/date_util.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:card_coin/utils/startup_time.dart';
import 'package:chipcore_sdk/src/demo/utils/scan_util.dart' as chip_scan;
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';
import '../../../../../../bean/card_info_bean.dart';
import '../../../../../../common/common_action/action.dart';
import '../../../../../../http/address.dart';
import '../../../../../../http/http_manager.dart';
import '../../../../settings_page/card_manager_page/action.dart';
import '../../../add_detail_page/action.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';

Effect<MyCardState>? buildEffect() {
  return combineEffects(<Object, Effect<MyCardState>>{
    Lifecycle.initState: _onInit,
    MyCardAction.loadData: _onLoadData,
    MyCardAction.getkline: _onLoadKlineData,
    MyCardAction.scanCardClick: _onScanCardClick,
    MyCardAction.handlScanCardClick: _onHandleScanCardClick,
    CardManagerAction.deleteItem: (action, ctx) =>
        ctx.dispatch(MyCardActionCreator.onLoadData()),
    InvestmentProcessAction.notificationback: (action, ctx) =>
        ctx.dispatch(MyCardActionCreator.onRetBtn()),
    CommonAction.languageChanged: _onInit,
    MyCardAction.resetActiveBtn: _onHandleResetActiveBtn,
    TabWalletAction.reloadMainData: _onReloadMainData,
    MyCardAction.reloadMainData: _onMyReloadMainData,
    AddDetailAction.updateLink: (action, ctx) =>
        ctx.dispatch(MyCardActionCreator.onLoadData()),
    GroupCardDetailAction.deletedUpateCardDetail: _onRefreshAddHoldCardStatus,
    MyCardAction.loadCardInfo: _onLoadCardInfo,
    MyCardAction.pushWalletPage: _onPushWalletClick,
    MyCardAction.investmentlist: _onInvestmentClick,
    MyCardAction.addHoldCard: _onAddHoldCard,
    MyCardAction.investmentExpanded: _onExpandedClick,
    MyCardAction.pushInvestmentActvite: _onActiveClick,
    MyCardAction.exchangSwitch: _onExchangeClick,
    InvestmentAction.activitedSucCard: _onCardActivedSuc,
    MyCardAction.deletedCard: _onRemovedClick,
    MyCardAction.updateCurrentNum: _onUpdateCurNum,
    MyCardAction.changeVerticalLines: _onUpdatechangeVerticalLines,
    MyCardAction.dapplist: _onDapplist,
    MyCardAction.dappDetail: _onDappDetail,
    MyCardAction.mingeCardClick: _onMingeCardClick,
    MyCardAction.pushOneWalletPage: _onPushOneWalletClick,
    MyCardAction.onLoadMessageDetail: _onLoadMessageDetail,
    MyCardAction.gotoChainStamp: _onGotoChainStamp,
    MyCardAction.updateCurrency: _onUpdateCurrency,
    MyCardAction.loadCurrencyInfo: _onLoadcurrencyInfo,
    MyCardAction.clearCardDetail: clearCardDetail,
  });
}

Future<void> _onInit(Action action, Context<MyCardState> ctx) async {
  // ctx.dispatch(MyCardActionCreator.onLoadData());
  ctx.state.domainUrl = await _loadDomain(ctx);
  print("ndefdmoma:${ctx.state.domainUrl}");
  print("ndefdmoma_syncUid:${ctx.state.isNeedSyncUid}");
  if (ctx.state.domainUrl == null) {
    // domain加载失败时保持扫卡按钮状态，不进入错误页
    return;
  }
  if (ctx.state.taskItemId != null) {
    ctx.dispatch(MyCardActionCreator.onScanCardClick());
  }
}

Future<String?> _loadDomain(Context<MyCardState> ctx) async {
  var params = <String, dynamic>{};
  String? cardUuid = await LocalStorage.getCardUuid();
  if (cardUuid != null) {
    params['uid'] = cardUuid;
  }
  final result = await HttpManager.getInstance()
      .post(NetworkAddress.smartCardConfig, null, data: params);

  // return "";
  if (result.isSuccess) {
    ctx.state.isNeedSyncUid = result.data['isNeedSyncUid'] ?? false;
    return result.data['ndefDomain'] ?? "";
  }

  showDialog(
      context: ctx.context,
      builder: (context) {
        return ZenggeTextAlertDialog(result.message);
      }).then((value) async {
    // ctx.state.domainUrl ??= await _loadDomain();
    // ctx.dispatch(MyCardActionCreator.onLoadData());
  });
  return null;
}

Future<void> _onLoadData(Action action, Context<MyCardState> ctx) async {
  String? cardUuid = await LocalStorage.getCardUuid();
  if (cardUuid != null) {
    ctx.dispatch(MyCardActionCreator.onShowLoading());
    print("_onLoadData cardUuid:$cardUuid");
    ctx.dispatch(MyCardActionCreator.onLoadCardInfo(cardUuid));
  } else {
    ctx.dispatch(MyCardActionCreator.onLoadSuccess());
  }
}

Future<void> _onHandleResetActiveBtn(
    Action action, Context<MyCardState> ctx) async {
  ctx.state.isSliButtonComplete = false;
  ctx.state.slideKey.currentState?.reset();
  ctx.dispatch(
      MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
}

Future<void> _onLoadCardInfo(Action action, Context<MyCardState> ctx) async {
  String cardId = action.payload;
  StartupTime.mark('mycard_detail_request_begin');
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.cardDetailUrl, null, data: {'uid': cardId});
  StartupTime.mark('mycard_detail_response_done');
  if (result.isSuccess) {
    if (result.data != null) {
      final languageResource = ctx.state.languageResource!;
      SmartCardDetail cardDetail = SmartCardDetail.fromJson(result.data);
      print(
          "[MyCard] investment.status=${cardDetail.investment?.status}, isShowPostCardActivation will be set by config");
      _onCheckPageConfig(action, ctx, cardDetail);

      // Tab 钱包页最外层 Container 背景：扫卡成功后统一为浅蓝（见 tab_wallet_page view）
      ctx.broadcast(MyCardActionCreator.onChangeBgcolorInReTap(false));

      if (cardDetail.investmentForecast != null) {
        List<FlSpot> list =
            cardDetail.investmentForecast!.investments!.map((e) {
          return FlSpot(
              cardDetail.investmentForecast!.investments!.indexOf(e).toDouble(),
              double.parse(e.price!));
        }).toList();
        double maxX = 0.0;
        double maxY = 0.0;
        double minX = list.isNotEmpty ? list.last.x : 0.0;
        double minY = 9999999999999.0;
        bool isBtc = false;
        if (cardDetail.investment?.assetToName!.toUpperCase() ==
            'bitcoin'.toUpperCase()) {
          isBtc = true;
        }
        int indexMax = 0;

        for (var element in cardDetail.investmentForecast!.investments!) {
          if (element.price != null) {
            double price = double.parse(element.price!);
            if (price > maxY) {
              maxY = price;
              indexMax =
                  cardDetail.investmentForecast!.investments!.indexOf(element);
            }
            if (price < minY) {
              minY = price;
            }
          }
          if (element.investmentTimestamp! > maxX) {
            maxX = element.investmentTimestamp!.toDouble();
          }
          if (element.investmentTimestamp! < minX) {
            minX = element.investmentTimestamp!.toDouble();
          }
        }
        ctx.state.maxSpot = list.isNotEmpty ? list[indexMax] : null;
        if (isBtc) {
          ctx.state.maxY = maxY + 12000.0;
          ctx.state.minY = (minY - 6000.0).clamp(0, double.infinity);
        } else {
          double range = maxY - minY;
          double padding =
              range > 0 ? range * 0.5 : (maxY > 0 ? maxY * 0.1 : 1.0);
          ctx.state.maxY = maxY + padding;
          ctx.state.minY = (minY - padding * 0.5).clamp(0, double.infinity);
        }
        ctx.state.isBTC = isBtc;
        ctx.state.avargX = list.isNotEmpty ? (maxX - minX) / list.length : 0.0;
        ctx.state.spotList = list;
        print('list333333:minY:$minY,minY:$maxY,isBtc:$isBtc');
      }
      if (!(cardDetail.available ?? false)) {
        var result = await showDialog(
            context: ctx.context,
            builder: (context) {
              return ZenggeTextAlertDialog(
                languageResource.inActivateTips,
                titleText: languageResource.tip,
                enableCancel: true,
                confirmText: languageResource.activateNow,
              );
            });
        if (result == true) {
          Navigator.of(ctx.context).pushNamed('activateDetailPage',
              arguments: {'uuid': cardDetail.uid});
        }
        return;
      }

      LocalStorage.saveCardUuid(cardId);
      LocalStorage.saveCardNo(cardId, cardDetail.cardNo!);
      String? cardSwitch = await LocalStorage.getString(
          LocalStorage.cardSwitched + cardDetail.uid!);
      if (cardSwitch == null) {
        ctx.state.isSwitched = true;
      } else {
        ctx.state.isSwitched = cardSwitch == '1' ? true : false;
      }
      print("ctx.state.isSwitched:${ctx.state.isSwitched}");
      LogUtils.i("MyCardPage", "card_switch:$cardSwitch");
      LocalStorage.saveString(
          LocalStorage.customerSmartCardId + cardDetail.uid!,
          cardDetail.customerSmartCardId!);
      StartupTime.mark('mycard_detail_ready_to_render');
      ctx.dispatch(MyCardActionCreator.onLoadSuccess(cardDetail: cardDetail));
      _scheduleKlineLoad(ctx, cardDetail);
      _scheduleDeferredContentLoads(ctx, cardDetail);
      if (ctx.state.isSwitched == true && cardDetail.held! == false) {
        Future.delayed(const Duration(seconds: 1)).then((value) => ctx.dispatch(
            MyCardActionCreator.onAddHoldCard(cardDetail.uid!,
                showSuccessToast: false)));
      }
      print("messageDetail11:${cardDetail.messageDetail}");
      if (cardDetail.messageDetail != null) {
        print("messageDetail:${cardDetail.messageDetail}");
        ctx.dispatch(
            MyCardActionCreator.onLoadMessageDetail(cardDetail.messageDetail!));
      }
    } else {
      showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(result.message);
          }).then((value) async {
        // ctx.state.domainUrl ??= await _loadDomain();
        // ctx.dispatch(MyCardActionCreator.onLoadData());
      });
      ctx.dispatch(MyCardActionCreator.onLoadFailure(result.message));
      return;
    }
  } else {
    showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(result.message);
        }).then((value) async {
      // ctx.state.domainUrl ??= await _loadDomain();
      // ctx.dispatch(MyCardActionCreator.onLoadData());
    });
    ctx.dispatch(MyCardActionCreator.onLoadFailure(result.message));
    return;
  }
}

void _onCheckPageConfig(
    Action action, Context<MyCardState> ctx, SmartCardDetail detail) {
  PageFieldConfigInfo info = ctx.state.pageConfig;

  List<PageFieldConfig> infoList = detail.pageFieldConfig ?? [];
  if (infoList.isNotEmpty) {
    for (var element in infoList) {
      print("element.fieldCode:${element.fieldCode}");
      if (element.fieldCode == "k_line") {
        info.isShowKLine = true;
      }
      if (element.fieldCode == "total_investment") {
        print("total_investment:${element.fieldCode}");
        info.isShowTotalInvestment = true;
      }
      if (element.fieldCode == "current_value") {
        info.isShowCurValue = true;
      }
      if (element.fieldCode == "current_price") {
        info.isShowCurPirce = true;
      }
      if (element.fieldCode == "profit") {
        info.isShowProfit = true;
      }
      if (element.fieldCode == "roi") {
        info.isShowRoi = true;
      }
      if (element.fieldCode == "card_number") {
        info.isShowCardNo = true;
      }
      if (element.fieldCode == "add_collection") {
        info.isShowCardAddCollection = true;
      }

      if (element.fieldCode == "detail") {
        info.isShowCardDetail = true;
      }

      if (element.fieldCode == "postcard_description") {
        info.isShowCardDescription = true;
      }

      if (element.fieldCode == "wallet") {
        info.isShowWallet = true;
      }

      if (element.fieldCode == "card_number") {
        info.isShowCardNo = true;
      }
      if (element.fieldCode == "card_balance") {
        info.isShowCardbalance = true;
      }
      if (element.fieldCode == "investment_amount") {
        info.isShowCardMount = true;
      }
      if (element.fieldCode == "k_line") {
        info.isShowKLine = true;
      }
      if (element.fieldCode == "line_chart") {
        info.isShowLineChart = true;
      }
      if (element.fieldCode == "investment_max_periods") {
        info.isShowCardMaxPeriods = true;
      }

      if (element.fieldCode == "investment_executed_count") {
        info.isShowCardExecutedCount = true;
      }
      if (element.fieldCode == "postcard_name") {
        info.isShowPostCardName = true;
      }
      if (element.fieldCode == "postcard_mobile") {
        info.isShowPostCardMobile = true;
      }
      if (element.fieldCode == "postcard_email") {
        info.isShowPostCardEmail = true;
      }
      if (element.fieldCode == "postcard_address") {
        info.isShowPostCardAddress = true;
      }
      if (element.fieldCode == "card_logo") {
        info.isShowCardLogo = true;
      }

      if (element.fieldCode == "background_image") {
        info.isShowCardBackgroundImage = true;
      }

      if (element.fieldCode == "merchant_title") {
        info.isShowCardMerchantTitle = true;
      }

      if (element.fieldCode == "merchant_logo") {
        info.isShowCardMerchantLogo = true;
      }
      if (element.fieldCode == "merchant_name") {
        info.isShowCardMerchantName = true;
      }

      if (element.fieldCode == "card_shape") {
        info.isShowCardShape = true;
      }

      if (element.fieldCode == "card_shape_image") {
        info.isShowCardShapeImage = true;
      }

      if (element.fieldCode == "card_brand_image") {
        info.isShowCardBrandImage = true;
      }

      if (element.fieldCode == "card_brand") {
        info.isShowCardBrand = true;
      }

      if (element.fieldCode == "balance") {
        info.isShowCardTotalBalance = true;
      }

      if (element.fieldCode == "investment_plan_name") {
        info.isShowPostCardPlan = true;
      }
      if (element.fieldCode == "investment_cycle") {
        info.isShowPostCardCycle = true;
      }
      if (element.fieldCode == "re_top") {
        info.isShowPostCardReTap = true;
      }
      if (element.fieldCode == "investment_activation") {
        info.isShowPostCardActivation = true;
      }
      if (element.fieldCode == "investment_info") {
        info.isShowPostCardContact = true;
      }
      if (element.fieldCode == "investment_status") {
        info.isShowPStatus = true;
      }
      if (element.fieldCode == "dapp_list") {
        print("dapp_list:${element.fieldCode}");
        info.isShowDapplist = true;
      }

      if (element.fieldCode == "chain_stamp") {
        info.isShowCardChainStamp = true;
      }
    }

    if (info.isShowTotalInvestment == false &&
        info.isShowCurValue == false &&
        info.isShowCurPirce == false &&
        info.isShowProfit == false &&
        info.isShowRoi == false) {
      info.isShowPreformace = false;
      print("isShowPreformace1:${info.isShowPreformace}");
    } else {
      print("isShowPreformace2:${info.isShowPreformace}");
      info.isShowPreformace = true;
    }
    ctx.state.pageConfig = info;
    if (isShowActiveTopCard(ctx.state)) {
      ctx.state.pageConfig.isShowPreformace = true;
    } else {
      ctx.state.pageConfig.isShowPreformace = false;
    }
    print("pageConfig:${ctx.state.pageConfig.isShowPreformace}");
  }
}

void _scheduleDeferredContentLoads(
    Context<MyCardState> ctx, SmartCardDetail cardDetail) {
  Future.delayed(const Duration(milliseconds: 120), () {
    if (ctx.state.cardDetail?.uid != cardDetail.uid) {
      return;
    }
    StartupTime.mark('mycard_deferred_content_begin');
    // 兜底触发：避免首轮触发因时序被跳过导致 KLine 不请求。
    _triggerKlineLoad(ctx, cardDetail, source: 'deferred');
    if (cardDetail.walletAddresses != null &&
        cardDetail.walletAddresses!.isNotEmpty &&
        ctx.state.pageConfig.isShowCardTotalBalance == true) {
      ctx.dispatch(MyCardActionCreator.onLoadCurrencyInfo());
    }

    if (ctx.state.pageConfig.isShowDapplist == true) {
      ctx.dispatch(MyCardActionCreator.onGetDapplist());
    }
  });
}

void _scheduleKlineLoad(Context<MyCardState> ctx, SmartCardDetail cardDetail) {
  // 首屏关键内容优先：稍后触发 KLine，降低首屏阶段重建压力。
  Future.delayed(const Duration(milliseconds: 180), () {
    if (ctx.state.cardDetail?.uid != cardDetail.uid) {
      return;
    }
    _triggerKlineLoad(ctx, cardDetail, source: 'post_detail');
  });
}

void _triggerKlineLoad(Context<MyCardState> ctx, SmartCardDetail cardDetail,
    {required String source}) {
  if (ctx.state.pageConfig.isShowKLine != true) {
    print('[KLINE] skip trigger, isShowKLine=false, source=$source');
    return;
  }
  final String? klineCode = _resolveKlineCode(cardDetail);
  print('[KLINE] trigger source=$source, resolvedCode=$klineCode');
  if (klineCode != null) {
    ctx.dispatch(MyCardActionCreator.onGetKLine(klineCode));
  } else {
    // 某些卡片没有 cryptoCode，直接用 investmentForecast 数据兜底绘制。
    final fallback = _buildFallbackKlineFromForecast(cardDetail);
    print('[KLINE] fallback by forecast, points=${fallback.length}');
    ctx.dispatch(MyCardActionCreator.onKline(fallback));
  }
}

String? _resolveKlineCode(SmartCardDetail cardDetail) {
  if (cardDetail.wallects != null) {
    for (final wallet in cardDetail.wallects!) {
      final code = wallet.code.trim();
      if (code.isNotEmpty) {
        return code;
      }
    }
  }

  final String? assetTo = cardDetail.investment?.assetTo;
  if (assetTo != null && assetTo.trim().isNotEmpty) {
    return assetTo.trim();
  }

  final String? assetFrom = cardDetail.investment?.assetFrom;
  if (assetFrom != null && assetFrom.trim().isNotEmpty) {
    return assetFrom.trim();
  }

  final String? assetToName = cardDetail.investment?.assetToName;
  if (assetToName != null && assetToName.trim().isNotEmpty) {
    return assetToName.trim();
  }

  final String? forecastName = cardDetail.investmentForecast?.name;
  if (forecastName != null && forecastName.trim().isNotEmpty) {
    return forecastName.trim();
  }

  return null;
}

bool isShowActiveTopCard(MyCardState state) {
  bool result = (state.pageConfig.isShowTotalInvestment == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.totalInvestment != null) ||
      (state.pageConfig.isShowCurValue == true ||
              state.pageConfig.isShowCurPirce == true) &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast!.totalValue != null ||
      state.pageConfig.isShowCurPirce == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.price != null ||
      (state.pageConfig.isShowCurPirce == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.price != null) ||
      (state.pageConfig.isShowProfit == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.totalRevenue != null) ||
      (state.pageConfig.isShowRoi == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.earningRate != null) ||
      (state.pageConfig.isShowRoi == true &&
          state.cardDetail?.investmentForecast != null &&
          state.cardDetail?.investmentForecast?.earningRate != null);
  return result;
}

Future<void> _onAddHoldCard(Action action, Context<MyCardState> ctx) async {
  final payload = action.payload;
  String cardId = '';
  bool showSuccessToast = true;
  if (payload is String) {
    cardId = payload;
  } else if (payload is Map) {
    cardId = payload['cardId']?.toString() ?? '';
    showSuccessToast = payload['showSuccessToast'] != false;
  }
  if (cardId.isEmpty) {
    return;
  }
  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.showNoMask();
  var result = await HttpManager.getInstance()
      .post(NetworkAddress.addCardHoldUrl, null, data: {'uid': cardId});
  await pr.hide();
  if (result.isSuccess) {
    if (showSuccessToast) {
      showToast('Add hold successful!');
    }
    if (result.data != null) {
      SmartCardDetail cardDetail1 = SmartCardDetail.fromJson(result.data);
      final cardDetail = ctx.state.cardDetail!.copyWidth(
          held: true, customerSmartCardId: cardDetail1.customerSmartCardId!);
      ctx.state.isSwitched = true;
      ctx.state.customerSmartCardId = cardDetail.customerSmartCardId;
      LocalStorage.saveString(
          LocalStorage.customerSmartCardId + ctx.state.cardDetail!.uid!,
          cardDetail.customerSmartCardId!);
      LocalStorage.saveString(LocalStorage.cardSwitched + cardDetail.uid!, '1');
      ctx.dispatch(MyCardActionCreator.onLoadSuccess(cardDetail: cardDetail));

      ctx.broadcast(MyCardActionCreator.onRefreshHoldCard());
    }
  } else {
    if (showSuccessToast) {
      showToast('Add hold failed:${result.message}');
    }
    ctx.state.isSwitched = false;
    ctx.dispatch(
        MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail!));
  }
}

Future<void> _onRemovedClick(Action action, Context<MyCardState> ctx) async {
  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  String customerSmartCardId = action.payload;
  var deleteResult = await HttpManager.getInstance().post(
      NetworkAddress.deleteSmartCardUrl, null,
      data: jsonEncode([customerSmartCardId]));
  pr.hide();
  if (deleteResult.isSuccess) {
    if (deleteResult.data) {
      ctx.state.isSwitched = false;

      ctx.broadcast(GroupCardDetailActionCreator.onDeletedUpateCardDetail(
          ctx.state.cardDetail!.uid!));
      ctx.broadcast(GroupCardDetailActionCreator.onRefreshHoldCard());
    }
  }
}

Future<void> _onScanCardClick(Action action, Context<MyCardState> ctx) async {
  // ProgressDialog pr = ProgressDialog(ctx.context);
  // pr.show();
  ctx.state.domainUrl = await _loadDomain(ctx);
  // pr.hide();
  // if (ctx.state.domainUrl == null) {
  //   // 域名加载失败（如无网络），恢复页面状态，不继续执行扫卡流程
  //   ctx.dispatch(
  //       MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
  //   return;
  // }

  ///弹出窗口前要把之前的卡信息内容移除
  if (ctx.state.cardDetail != null) {
    ctx.broadcast(MyCardActionCreator.onChangeBgcolorInReTap(true));
    ctx.state.pageConfig = PageFieldConfigInfo();
  }

  int now = DateTime.now().millisecondsSinceEpoch;
  // 如果距离上次点击的时间小于 2 秒，则不触发
  if (now - ctx.state.lastClickedTime < 2000) {
    print("tiem less than 2s");
    return;
  }
  ctx.state.lastClickedTime = now;
  String? cardUuid = await LocalStorage.getCardUuid();
  print("_onScanCardClick-cardUuid:$cardUuid");
  final chipResp = await chip_scan.ScanUtil.scanOnly(
    checkLock: true,
    needSyncUid: true,
    ndefLink: ctx.state.domainUrl,
  );
  final scanResponse = ScanResponse(
    chipResp.isSuccess,
    isActivated: chipResp.data?.isActivated,
    resetCount: chipResp.data?.resetCount,
    data: chipResp.data?.cardId,
    message: chipResp.message,
    sw1: chipResp.sw1,
    sw2: chipResp.sw2,
  );
  // final scanResponse = await ScanUtil.scanCard(ctx.context, runnable: GetPrivateKeyRunnable());
  // final scanResponse = await ScanUtil.scanCard(ctx.context, runnable: GetDerivePrivateKeyRunnable('8000002C8000003C800000000000000000000000'));
  if (scanResponse.isSuccess) {
    print("_onScanCardClick-scanResponse.data:${scanResponse.data}");
    String? cardUuid = scanResponse.data;
    if (cardUuid != null && cardUuid == ctx.state.cardDetail?.uid) {
      return;
    }
    //cardUuid = "04594cfafe1f90";
    LogUtils.uid = cardUuid!;
    String? cardActivated =
        await LocalStorage.getString(LocalStorage.cardActivited + cardUuid);
    String? cardResetcount =
        await LocalStorage.getString(LocalStorage.cardResetCount + cardUuid);
    print(
        'save card_activated:$cardActivated,card_ResetCount:$cardResetcount,scanResponse.resetCount:${scanResponse.resetCount},scanResponse.isActivated:${scanResponse.isActivated}');
    if (!(scanResponse.isActivated ?? false)) {
      LocalStorage.remove(LocalStorage.cardInfo + cardUuid);
      if (cardActivated != null && cardActivated == "1") {
        LocalStorage.remove(LocalStorage.cardActivited + cardUuid);
        LocalStorage.remove(LocalStorage.cardResetCount + cardUuid);
        _resetDataWithCardId(action, ctx, cardUuid);
      }
      LocalStorage.save(LocalStorage.cardActivited + cardUuid, '0');
      LocalStorage.save(
          LocalStorage.cardResetCount + cardUuid, "${scanResponse.resetCount}");
      print('save_card_activated:0');
    } else if (scanResponse.isActivated == true &&
        cardResetcount != null &&
        scanResponse.resetCount != null &&
        cardResetcount != scanResponse.resetCount.toString()) {
      LocalStorage.remove(LocalStorage.cardInfo + cardUuid);
      LocalStorage.remove(LocalStorage.cardActivited + cardUuid);
      LocalStorage.remove(LocalStorage.cardResetCount + cardUuid);
      _resetDataWithCardId(action, ctx, cardUuid);
      LocalStorage.save(LocalStorage.cardActivited + cardUuid, '1');
      LocalStorage.save(
          LocalStorage.cardResetCount + cardUuid, "${scanResponse.resetCount}");
      print('save_card_activated:1');
    } else if (scanResponse.isActivated == true) {
      LocalStorage.save(LocalStorage.cardActivited + cardUuid, '1');
      LocalStorage.save(
          LocalStorage.cardResetCount + cardUuid, "${scanResponse.resetCount}");
      print('save_card_activated:2');
    }
    print("write ndef success:$cardUuid");

    StartupTime.mark('mycard_scan_success');
    // 每次扫卡都先清空旧卡片内容，确保加载态走骨屏而不是遮罩 loading。
    ctx.dispatch(MyCardActionCreator.onClearCardDetail());
    ctx.dispatch(MyCardActionCreator.onShowLoading());

    ctx.dispatch(MyCardActionCreator.onLoadCardInfo(cardUuid));
  } else {
    print("write ndef fail");
    if (scanResponse.message != "Session invalidated by user" &&
        scanResponse.message != "System resource unavailable" &&
        scanResponse.message != "用户已取消") {
      if (scanResponse.message != null && scanResponse.message!.length <= 50) {
        await ScanUtil.unlockTip(
            scanResponse,
            ctx.context,
            scanResponse.data == null
                ? ctx.state.cardDetail?.uid
                : scanResponse.data!);
      }
    }
    // 无论取消还是错误，都需要从现有 cardDetail 恢复 pageConfig，
    // 因为扫卡前已将 pageConfig 置空，若不还原则页面空白。
    if (ctx.state.cardDetail != null) {
      ctx.state.pageConfig = PageFieldConfigInfo();
      _onCheckPageConfig(action, ctx, ctx.state.cardDetail!);
    }
    ctx.dispatch(
        MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
  }
}

void _resetDataWithCardId(
    Action action, Context<MyCardState> ctx, String cardUuid) async {
  final stringList =
      await LocalStorage.getStringList(LocalStorage.cardInfoList + cardUuid);
  if (stringList != null) {
    stringList.removeWhere((element) => element.contains(cardUuid));
    LocalStorage.remove(LocalStorage.cardInfoList + cardUuid);
  }

  ///清除原生本地缓存数据
  BlockchainPlatform.instance.clearLocalCurrency(cardUuid, []);
  await LocalStorage.remove(LocalStorage.cardInfo + cardUuid);
  String keyBTCInit = "${cardUuid}_btc_init";
  await LocalStorage.remove(keyBTCInit);
}

Future<void> _onPushWalletClick(Action action, Context<MyCardState> ctx) async {
  String cardId = action.payload;
  Navigator.of(ctx.context).pushNamed('myAssetPage',
      arguments: {'uid': cardId, 'cardDetail': ctx.state.cardDetail});
}

Future<void> _onInvestmentClick(Action action, Context<MyCardState> ctx) async {
  String cardId = action.payload;

  Navigator.of(ctx.context).pushNamed('myAssetPage',
      arguments: {'uid': cardId, 'cardDetail': ctx.state.cardDetail});
  // print(
  //     '_onInvestmentClick-cardId:${ctx.state.cardDetail!.investmentConfig!.investmentFlow}');
  // // if (ctx.state.cardDetail != null &&
  // //     ctx.state.cardDetail!.investmentConfig != null &&
  // //     ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE') {
  //   var result = await Navigator.of(ctx.context).pushNamed(
  //       'investmentSingleDetailPage',
  //       arguments: {'uid': cardId, 'id': ctx.state.cardDetail!.investment!.id});
  //   return;
  // }

  // if (ctx.state.cardDetail!.investment!.status == 'PROCESSING') {
  //   var result = await Navigator.of(ctx.context)
  //       .pushNamed('investmentProcessPage', arguments: {
  //     'uid': cardId,
  //     'formIndex': "1",
  //     'investmentConfig': ctx.state.cardDetail!.investmentConfig,
  //     'assetFrom': ctx.state.cardDetail!.investment!.assetFrom!,
  //     'isSingle':
  //         ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE',
  //     'id': ctx.state.cardDetail!.investment!.id
  //   });

  //   if (result != null) {
  //     print("iinvestmentProcessPage_reslut:${result}");
  //     ctx.state.isSliButtonComplete = false;
  //     ctx.state.slideKey.currentState?.reset();
  //     ctx.dispatch(
  //         MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
  //   }

  //   return;
  // }
  // Navigator.of(ctx.context).pushNamed('investmentPage', arguments: {
  //   'uid': cardId,
  //   'investmentConfig': ctx.state.cardDetail!.investmentConfig,
  //   'assetFrom': ctx.state.cardDetail!.investment!.assetFrom!,
  //   'isSingle':
  //       ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE'
  // });
}

Future<void> _onRefreshAddHoldCardStatus(
    Action action, Context<MyCardState> ctx) async {
  String uid = action.payload;
  SmartCardDetail? detail = ctx.state.cardDetail;

  if (detail != null) {
    String cardId = ctx.state.cardDetail!.uid!;
    if (cardId == uid) {
      ctx.state.isSwitched = false;
      final cardDetail = ctx.state.cardDetail!.copyWidth(held: false);
      LocalStorage.remove(
          LocalStorage.customerSmartCardId + ctx.state.cardDetail!.uid!);
      ctx.dispatch(MyCardActionCreator.onLoadSuccess(cardDetail: cardDetail));
    }
  }
}

void _onHandleScanCardClick(Action action, Context<MyCardState> ctx) {
  ctx.state.debouncer.run(() {
    ctx.dispatch(MyCardActionCreator.onScanCardClick());
  });
}

Future<void> _onExpandedClick(Action action, Context<MyCardState> ctx) async {
  ctx.state.isExpanded = !ctx.state.isExpanded;

  ctx.dispatch(
      MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
}

Future<void> _onActiveClick(Action action, Context<MyCardState> ctx) async {
  print(
      '_onActiveClick-start-status:${ctx.state.cardDetail!.investment?.status}');

  String cardId = action.payload;
  final cardConfig = ctx.state.cardDetail!.investmentConfig!.toString();
  LocalStorage.saveString(
      LocalStorage.cardInvestmentConfig + ctx.state.cardDetail!.uid!,
      cardConfig);
  var intervalExtend1 = "";
  var intervalExtend2 = "";
  var intervalExtend3 = "";
  if (ctx.state.selectInfo1 != null) {
    intervalExtend1 = ctx.state.selectInfo1!.value;
  } else {
    intervalExtend1 = ctx.state.cardDetail!.investment?.intervalExtend1 ?? "";
  }
  if (ctx.state.selectInfo2 != null) {
    intervalExtend2 = ctx.state.selectInfo2!.value;
  } else {
    intervalExtend2 = ctx.state.cardDetail!.investment?.intervalExtend2 ?? "";
  }
  if (ctx.state.selectInfo3 != null) {
    intervalExtend3 = ctx.state.selectInfo3!.value;
  } else {
    intervalExtend3 = ctx.state.cardDetail!.investment?.intervalExtend3 ?? "";
  }

  print(
      'investmentActivePage_intervalExtend1:$intervalExtend1,intervalExtend2:$intervalExtend2,intervalExtend3:$intervalExtend3');

  if (ctx.state.cardDetail!.investment?.status == 'PROCESSING') {
    var result = await Navigator.of(ctx.context)
        .pushNamed('investmentProcessPage', arguments: {
      'uid': cardId,
      'formIndex': "1",
      'investmentConfig': ctx.state.cardDetail!.investmentConfig,
      'assetFrom': ctx.state.cardDetail!.investment!.assetFrom!,
      'isSingle':
          ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE',
      'id': ctx.state.cardDetail!.investment?.id
    });

    if (result != null) {
      print("investmentProcessPage_reslut:$result");
      ctx.state.isSliButtonComplete = false;
      ctx.state.slideKey.currentState?.reset();
      ctx.dispatch(
          MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
    }

    return;
  }

  var reslut = await Navigator.of(ctx.context)
      .pushNamed('investmentActivePage', arguments: {
    'cardId': cardId,
    'intervalExtend1': intervalExtend1,
    'intervalExtend2': intervalExtend2,
    'intervalExtend3': intervalExtend3,
    'investmentConfig': ctx.state.cardDetail!.investmentConfig,
    'id': ctx.state.cardDetail!.investment?.id,
    'isSingle':
        ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE',
  });

  if (reslut != null) {
    print("investmentActivePage_reslut:$reslut");
    ctx.state.isSliButtonComplete = false;
    ctx.state.slideKey.currentState?.reset();
    ctx.dispatch(
        MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
  }
}

Future<void> _onCardActivedSuc(Action action, Context<MyCardState> ctx) async {
  print('_onCardActivedSuc-statrt');
  if (ctx.state.cardDetail == null) {
    print('_onCardActivedSuc- detail empty');
    return;
  }
  if (ctx.state.cardDetail != null &&
      ctx.state.cardDetail!.investment != null &&
      ctx.state.cardDetail!.investment!.status != 'INACTIVE') {
    print('_onCardActivedSuc- no need to refresh');
    return;
  }
  String cardId = ctx.state.cardDetail!.uid!;
  if (ctx.state.cardDetail != null) {
    ctx.dispatch(MyCardActionCreator.onClearCardDetail());
    print("_onCardActivedSuc:$cardId");
  }

  var result = await HttpManager.getInstance()
      .post(NetworkAddress.cardDetailUrl, null, data: {'uid': cardId});
  if (result.isSuccess) {
    if (result.data != null) {
      print("cardDetailUrl3333:$cardId");
      final languageResource = ctx.state.languageResource!;
      SmartCardDetail cardDetail = SmartCardDetail.fromJson(result.data);
      if (cardDetail.investmentForecast != null) {
        List<FlSpot> list =
            cardDetail.investmentForecast!.investments!.map((e) {
          return FlSpot(
              e.investmentTimestamp!.toDouble(), double.parse(e.price!));
        }).toList();
        double maxY = 0.0;
        double minY = 9999999999999.0;
        bool isBtc = false;
        if (cardDetail.investment?.assetToName!.toUpperCase() ==
            'BTC'.toUpperCase()) {
          isBtc = true;
        }
        for (var element in cardDetail.investmentForecast!.investments!) {
          if (element.price != null) {
            double price = double.parse(element.price!);
            if (price > maxY) {
              maxY = price;
            }
            if (price < minY) {
              minY = price;
            }
          }
        }

        ctx.state.maxY1 = maxY;
        ctx.state.minY = minY;

        ctx.state.spotList = list;
        print('list333333:minY:$minY,minY:$maxY,isBtc:$isBtc');
      }
      if (!(cardDetail.available ?? false)) {
        var result = await showDialog(
            context: ctx.context,
            builder: (context) {
              return ZenggeTextAlertDialog(
                languageResource.inActivateTips,
                titleText: languageResource.tip,
                enableCancel: true,
                confirmText: languageResource.activateNow,
              );
            });
        if (result == true) {
          Navigator.of(ctx.context).pushNamed('activateDetailPage',
              arguments: {'uuid': cardDetail.uid});
        }
        return;
      }
      print("cardDetailUrl_onLoadSuccess:$cardId");
      LocalStorage.saveCardUuid(cardId);
      LocalStorage.saveCardNo(cardId, cardDetail.cardNo!);
      ctx.dispatch(MyCardActionCreator.onLoadSuccess(cardDetail: cardDetail));
    } else {
      showDialog(
          context: ctx.context,
          builder: (context) {
            return ZenggeTextAlertDialog(result.message);
          }).then((value) async {
        //  ctx.dispatch(MyCardActionCreator.onLoadData());
      });
      ctx.dispatch(MyCardActionCreator.onLoadFailure(result.message));
      return;
    }
  } else {
    showDialog(
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(result.message);
        }).then((value) async {
      // ctx.dispatch(MyCardActionCreator.onLoadData());
    });
    ctx.dispatch(MyCardActionCreator.onLoadFailure(result.message));
    return;
  }
  print('_onCardActivedSuc-end');
}

Future<void> _onExchangeClick(Action action, Context<MyCardState> ctx) async {
  bool switchValue = action.payload;
  LocalStorage.saveString(
      LocalStorage.cardSwitched + ctx.state.cardDetail!.uid!,
      switchValue ? '1' : '0');

  ctx.state.isSwitched = switchValue;
  if (!ctx.state.isSwitched) {
    ///获取卡片信息缓存

    String? customerSmartCardId = await LocalStorage.getString(
        LocalStorage.customerSmartCardId + ctx.state.cardDetail!.uid!);
    print("_onExchangeClick:id:$customerSmartCardId");
    if (customerSmartCardId != null) {
      ctx.dispatch(MyCardActionCreator.onDeleteClick(customerSmartCardId));
    }
  } else {
    print("_onExchangeClick111:${ctx.state.cardDetail!.toJson()}");
    ctx.dispatch(MyCardActionCreator.onAddHoldCard(ctx.state.cardDetail!.uid!,
        showSuccessToast: true));
  }
}

Future<void> _onUpdateCurNum(Action action, Context<MyCardState> ctx) async {
  double cur = action.payload;
  print("curssss:$cur");
  ctx.state.oCur = ctx.state.newCur;
  ctx.state.newCur = cur;
  List olist = ctx.state.valueArr;
  olist[0] = olist[1];
  olist[1] = cur;
  print("curssss0:${ctx.state.oCur}，newCur：${ctx.state.newCur}");
  // 图表切换数值时触发震动（NFC 扫卡由系统震动处理，此处仅响应图表交互）
  bool? isCan = await Vibration.hasVibrator();
  if (isCan != null && isCan == true) {
    vibrate();
  }
  ctx.dispatch(MyCardActionCreator.onUpdateViewAfterUpdateCurrentNum(olist));
}

void vibrate() async {
  if (await Vibration.hasVibrator() ?? false) {
    print('开始震动');
    Vibration.vibrate(duration: 200); // 单次震动 500 毫秒
  }
}

Future<void> _onUpdatechangeVerticalLines(
    Action action, Context<MyCardState> ctx) async {
  ctx.dispatch(
      MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
}

Future<void> _onDapplist(Action action, Context<MyCardState> ctx) async {
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.dapplist, queryParameters: null);
  if (result.isSuccess) {
    List<dynamic> apps = result.data;
    print('dapplist:${apps.toString()}');
    List<DappInfo> list = apps.map((e) => DappInfo.fromJson(e)).toList();
    ctx.state.dapplist = list;
    ctx.dispatch(
        MyCardActionCreator.onLoadSuccess(cardDetail: ctx.state.cardDetail));
  } else {
    showToast('Failed to load dapp list:${result.message}');
  }
}

Future<void> _onDappDetail(Action action, Context<MyCardState> ctx) async {
  DappInfo info = action.payload;
  print('dappUrl:${info.href}');
  if (info.href != null && info.href!.isNotEmpty) {
    var uri = Uri.tryParse(info.href!);
    if (uri != null) {
      String pageUrl = info.href!;

      var userInfo = LocalStorage.getCacheUserInfo();
      if (pageUrl.contains("?")) {
        pageUrl = '$pageUrl&token=${userInfo?.accessToken ?? ''}';
      } else {
        pageUrl = '$pageUrl?token=${userInfo?.accessToken ?? ''}';
      }

      Navigator.of(ctx.context).pushNamed('webviewPage', arguments: {
        'pageUrl': pageUrl,
        'title': info.name,
        'showForward': true
      });
    } else {
      showToast("Invalid URL");
    }
    return;
  }
}

Future<void> _onReloadMainData(Action action, Context<MyCardState> ctx) async {
  ctx.dispatch(MyCardActionCreator.onLoadFailure("2"));
}

Future<void> _onMyReloadMainData(
    Action action, Context<MyCardState> ctx) async {
  ctx.state.domainUrl ??= await _loadDomain(ctx);
  if (ctx.state.domainUrl != null) {
    ctx.dispatch(MyCardActionCreator.onLoadData());
  }
}

_onMingeCardClick(Action action, Context<MyCardState> ctx) {
  // 功能待开发
  showToast("Feature under development");
}

_onPushOneWalletClick(Action action, Context<MyCardState> ctx) async {
  String cardId = ctx.state.cardDetail!.uid!;

  ///获取卡片信息缓存
  final cardInfoJson =
      await LocalStorage.getString(LocalStorage.cardInfo + cardId);
  print('_onPushWalletClick-cardInfoJson:$cardInfoJson, cardId:$cardId');
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
  Navigator.of(ctx.context).pushNamed('scanWalletPage', arguments: {
    'cardId': cardId,
  });
}

Future<void> _onLoadMessageDetail(
    Action action, Context<MyCardState> ctx) async {
  print("_onLoadMessageDetail:${action.payload}");
  CoinMessageDetail messageDetail = action.payload;
  var content = messageDetail.message;
  String subTitle = messageDetail.sender;

  var subTitleSpan = TextSpan(
    style: Theme.of(ctx.context).textTheme.titleSmall?.copyWith(
          color: Colors.grey,
        ),
    children: [
      TextSpan(
        text: subTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const TextSpan(text: " sent you a message:"),
    ],
  );
  await Future.delayed(const Duration(seconds: 2)).then((value) {
    showDialog(
        barrierDismissible: false, // 👈 关键：禁止点击外部关闭
        context: ctx.context,
        builder: (context) {
          return ZenggeTextAlertDialog(
            content,
            titleText: "New Message",
            subTitleSpan: subTitleSpan,
            confirmText: "Detail",
            cancelText: "Close",
            enableCancel: true,
          );
        }).then((value) async {
      if (value == true) {
        print("点击了confirm");
        Navigator.of(ctx.context).pushNamed('coinMessageDetailPage',
            arguments: {'noticeId': messageDetail.id});
      } else {}
    });
  });
}

Future<void> _onGotoChainStamp(Action action, Context<MyCardState> ctx) async {
  Navigator.of(ctx.context).pushNamed('addBlessPage');
}

Future<void> _onLoadKlineData(Action action, Context<MyCardState> ctx) async {
  String code = (action.payload as String?)?.trim() ?? "";
  if (code.isEmpty) {
    code = _resolveKlineCode(ctx.state.cardDetail ?? SmartCardDetail()) ?? "";
  }
  if (code.isEmpty) {
    final fallback = _buildFallbackKlineFromForecast(ctx.state.cardDetail);
    print('[KLINE] empty code, fallback points=${fallback.length}');
    ctx.dispatch(MyCardActionCreator.onKline(fallback));
    return;
  }

  ctx.state.KlineCode = code;
  print('[KLINE] request begin, code=$code');
  var result = await HttpManager.getInstance()
      .get(NetworkAddress.getKLines, queryParameters: {'cryptoCode': code});
  if (result.isSuccess) {
    final List<SalesData> lineDatas = _parseKlineSalesData(result.data);
    if (lineDatas.isEmpty) {
      lineDatas.addAll(_buildFallbackKlineFromForecast(ctx.state.cardDetail));
    }
    print('[KLINE] request success, points=${lineDatas.length}, code=$code');
    ctx.dispatch(MyCardActionCreator.onKline(lineDatas));
  } else {
    final fallback = _buildFallbackKlineFromForecast(ctx.state.cardDetail);
    print(
        '[KLINE] request fail, fallback points=${fallback.length}, msg=${result.message}');
    ctx.dispatch(MyCardActionCreator.onKline(fallback));
    showToast('Failed to klinedata list:${result.message}');
  }
}

List<SalesData> _parseKlineSalesData(dynamic rawData) {
  final List<SalesData> lineDatas = [];
  if (rawData is! List) {
    return lineDatas;
  }

  for (final item in rawData) {
    try {
      int? timestamp;
      double? price;

      if (item is List) {
        if (item.length < 2) {
          continue;
        }
        timestamp = int.tryParse(item[0].toString());
        price = double.tryParse(item[1].toString());
      } else if (item is Map) {
        final dynamic t = item['timestamp'] ?? item['time'] ?? item['ts'];
        final dynamic p =
            item['price'] ?? item['close'] ?? item['value'] ?? item['y'];
        timestamp = int.tryParse(t?.toString() ?? '');
        price = double.tryParse(p?.toString() ?? '');
      }

      if (timestamp == null || price == null) {
        continue;
      }

      lineDatas.add(SalesData(
        DateTimeUitls.timestampToDate(timestamp),
        price,
        false,
        false,
      ));
    } catch (_) {
      continue;
    }
  }

  return lineDatas;
}

List<SalesData> _buildFallbackKlineFromForecast(SmartCardDetail? detail) {
  final List<SalesData> fallback = [];
  final investments = detail?.investmentForecast?.investments;
  if (investments == null || investments.isEmpty) {
    return fallback;
  }

  for (final item in investments) {
    final int? timestamp = item.investmentTimestamp;
    final double? price = double.tryParse(item.price ?? '');
    if (timestamp == null || price == null) {
      continue;
    }
    fallback.add(SalesData(
      DateTimeUitls.timestampToDate(timestamp),
      price,
      false,
      false,
    ));
  }
  return fallback;
}

Future<void> _onUpdateCurrency(Action action, Context<MyCardState> ctx) async {
  FiatInfo fiatInfo = ctx.state.currentFiat;
  var result1 = await Navigator.of(ctx.context)
      .pushNamed('selectFiatPage', arguments: {'fiatInfo': fiatInfo});
  if (result1 != null) {
    FiatInfo fiatInfo1 = result1 as FiatInfo;
    ctx.state.cryptoTotalPrice = "0";
    // 存本地

    ctx.dispatch(MyCardActionCreator.onUpdateFiat(fiatInfo1));
    ctx.dispatch(MyCardActionCreator.onLoadCurrencyInfo());
  }
}

Future<void> _onLoadcurrencyInfo(
    Action action, Context<MyCardState> ctx) async {
  if (ctx.state.cardDetail == null) {
    return;
  }
  String id = "";
  if (ctx.state.cardDetail!.walletAddresses != null &&
      ctx.state.cardDetail!.walletAddresses!.isNotEmpty) {
    id = ctx.state.cardDetail!.walletAddresses![0].id!;
  }

  Map<String, dynamic>? parameters = {'id': id};

  print("_loadCurrencyid:$id");

  var currencyInfoResult = await HttpManager.getInstance()
      .post(NetworkAddress.currencyAddressDetail, null, data: parameters);

  if (currencyInfoResult.isSuccess) {
    final responseData = currencyInfoResult.data;
    if (responseData == null || responseData is! Map) {
      return;
    }

    final balanceData = responseData['balance'];
    if (balanceData == null || balanceData is! Map) {
      return;
    }

    final balanceJson = Map<String, dynamic>.from(balanceData);

    ctx.state.sumBalanceInfo = SumBalanceNewInfo.fromJson(balanceJson);
    print("_loadCurrencyInfo688");

    _onGetTotalBalance(action, ctx);
  }
}

void _onGetTotalBalance(Action action, Context<MyCardState> ctx) {
  var temp2 = NumberUtils.getFullCountBetweenTwoNumber(
      ctx.state.currentFiat.currentPrice.toString(),
      ctx.state.sumBalanceInfo == null
          ? "0.00"
          : ctx.state.sumBalanceInfo!.price.toString(),
      2);
  var result = NumberUtils.getFullCountBetweenTwoNumber(
      temp2,
      ctx.state.sumBalanceInfo == null
          ? "0.00"
          : ctx.state.sumBalanceInfo!.balance.toString(),
      2);

  result = NumberUtils.getFullCountWithLength(
      result, int.parse(ctx.state.currentFiat.scale));
  if (ctx.state.currentFiat.currentPrice.toString() == "1") {
    result = ctx.state.sumBalanceInfo != null
        ? ctx.state.sumBalanceInfo!.usd.toString()
        : result;
  }
  ctx.dispatch(MyCardActionCreator.onCryptoTotalPrice(result));
}

void clearCardDetail(Action action, Context<MyCardState> ctx) {
  ctx.state.cardDetail = null;
  ctx.state.pageConfig = PageFieldConfigInfo();
}
