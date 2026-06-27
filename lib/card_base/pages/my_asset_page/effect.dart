import 'dart:convert';
import 'package:card_coin/card_base/bean/asset_summary_info.dart';
import 'package:card_coin/card_base/utils/log_util.dart';
import 'package:card_coin/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/pigeons/blockchain_platform_interface.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MyAssetState>? buildEffect() {
  return combineEffects(<Object, Effect<MyAssetState>>{
    Lifecycle.initState: _onInit,
    MyAssetAction.loadData: _onloadData,
    MyAssetAction.pushWalletPage: _onPushWalletClick,
    MyAssetAction.investmentlist: _onInvestmentClick,
    MyAssetAction.selectType: _onSelectType,
    MyAssetAction.selectTooltip: _onSelectTip,
    MyAssetAction.pushExchange: _onPushExchange,
    MyAssetAction.pushCashOut: _onPushCashOut,
  });
}

void _onInit(Action action, Context<MyAssetState> ctx) {
  ctx.dispatch(MyAssetActionCreator.onLoadData());
}

Future<void> _onloadData(Action action, Context<MyAssetState> ctx) async {
  Map<String, dynamic> params = {
    "uid": ctx.state.uid,
  };
  LogUtils.uid = ctx.state.uid;

  var resultData = await HttpManager.getInstance()
      .post(NetworkAddress.assetSummary, null, data: params);
  if (resultData.isSuccess) {
    AssetSummaryInfo assetSummaryInfo =
        AssetSummaryInfo.fromJson(resultData.data);
    //   List<VerifyMethod> verifyMethods =
    //       datas.map((e) => VerifyMethod.fromJson(e)).toList();
    List<AssetTypeData> types = assetSummaryInfo.assetTypeData!;

    ctx.state.selectedTypes = types;
    print('assetSummary resultData:${resultData.data}');
    ctx.dispatch(MyAssetActionCreator.onLoadSuccess(assetSummaryInfo));
    ctx.dispatch(MyAssetActionCreator.onSelectType('ALL'));
  } else {
    // 拦截器已对 40000（登录过期）、830016（钱包未同步）、10003333（VPN 异常）
    // 弹过 dialog 并做了路由处理，此处不重复弹窗，否则会出现双弹窗甚至二次 pop 崩溃。
    const interceptorHandledCodes = {40000, 830016, 10003333};
    if (!interceptorHandledCodes.contains(resultData.code)) {
      final BuildContext currentContext = ctx.context;
      showDialog(
          context: currentContext,
          builder: (context) {
            return ZenggeTextAlertDialog(resultData.message);
          }).then((value) {
        if (currentContext.mounted) {
          Navigator.of(currentContext).pop();
        }
      });
    }
    ctx.dispatch(MyAssetActionCreator.onLoadFailure(resultData.message));
    return;
  }
}

Future<void> _onPushWalletClick(
    Action action, Context<MyAssetState> ctx) async {
  String cardId = action.payload;

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

Future<void> _onInvestmentClick(
    Action action, Context<MyAssetState> ctx) async {
  String cardId = action.payload;
  print(
      '_onInvestmentClick-cardId:${ctx.state.cardDetail!.investmentConfig!.investmentFlow}');
  if (ctx.state.cardDetail != null &&
      ctx.state.cardDetail!.investmentConfig != null &&
      ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE') {
    await Navigator.of(ctx.context).pushNamed('investmentSingleDetailPage',
        arguments: {'uid': cardId, 'id': ctx.state.cardDetail!.investment!.id});
    return;
  }

  if (ctx.state.cardDetail!.investment!.status == 'PROCESSING') {
    var result = await Navigator.of(ctx.context)
        .pushNamed('investmentProcessPage', arguments: {
      'uid': cardId,
      'formIndex': "1",
      'investmentConfig': ctx.state.cardDetail!.investmentConfig,
      'assetFrom': ctx.state.cardDetail!.investment!.assetFrom!,
      'isSingle':
          ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE',
      'id': ctx.state.cardDetail!.investment!.id
    });

    if (result != null) {
      print("iinvestmentProcessPage_reslut:$result");

      // ctx.dispatch(MyAssetActionCreator.onLoadSuccess());
    }

    return;
  }
  Navigator.of(ctx.context).pushNamed('investmentPage', arguments: {
    'uid': cardId,
    'investmentConfig': ctx.state.cardDetail!.investmentConfig,
    'assetFrom': ctx.state.cardDetail!.investment!.assetFrom!,
    'isSingle':
        ctx.state.cardDetail!.investmentConfig!.investmentFlow == 'SIMPLE'
  });
}

Future<void> _onSelectType(Action action, Context<MyAssetState> ctx) async {
  String type = action.payload;
  ctx.state.selectedType = type;
  if (type == 'ALL') {
    ctx.state.selectedShowPrice =
        ctx.state.assetSummaryInfo?.usdDisplayAmount ?? "0.0";
  } else {
    for (var element in ctx.state.assetSummaryInfo?.assetTypeData ?? []) {
      if (element.assetType == type) {
        ctx.state.selectedShowPrice = element.usdDisplayAmount ?? "0.0";
        break;
      }
    }
  }
  if (ctx.state.assetSummaryInfo != null) {
    ctx.dispatch(
        MyAssetActionCreator.onLoadSuccess(ctx.state.assetSummaryInfo!));
  }
}

Future<void> _onSelectTip(Action action, Context<MyAssetState> ctx) async {
  String tip = action.payload;
  ctx.state.tooltip = tip;
  ctx.dispatch(MyAssetActionCreator.onLoadSuccess(ctx.state.assetSummaryInfo!));
}

Future<void> _onPushExchange(Action action, Context<MyAssetState> ctx) async {
  await Navigator.of(ctx.context).pushNamed(
    'exchangePage',
    arguments: {'uid': ctx.state.uid},
  );
}

Future<void> _onPushCashOut(Action action, Context<MyAssetState> ctx) async {
  // 从资产摘要中找 FIAT 资产，获取法币 symbol 和余额
  final allAssets = ctx.state.assetSummaryInfo?.assetListData ?? [];
  final fiatAsset = allAssets.firstWhere(
    (e) => (e.assetType ?? '').toUpperCase() == 'FIAT',
    orElse: () => allAssets.isNotEmpty ? allAssets.first : AssetListData(),
  );
  await Navigator.of(ctx.context).pushNamed(
    'cashOutPage',
    arguments: {
      'uid': ctx.state.uid,
      'symbol': fiatAsset.symbol ?? '',
      'balance': fiatAsset.balance ?? '',
    },
  );
}
