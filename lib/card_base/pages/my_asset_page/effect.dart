import 'dart:convert';
import 'dart:async';
import 'package:card_coin/bean/page_field_config.dart';
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
import 'package:card_coin/utils/deep_link_manager.dart';
import 'action.dart';
import 'state.dart';

StreamSubscription<RefreshMyAssetEvent>? _refreshMyAssetSub;

Effect<MyAssetState>? buildEffect() {
  return combineEffects(<Object, Effect<MyAssetState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
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
  _refreshMyAssetSub?.cancel();
  _refreshMyAssetSub = eventBus.on<RefreshMyAssetEvent>().listen((_) {
    if (!ctx.context.mounted) return;
    ctx.dispatch(MyAssetActionCreator.onLoadData());
  });

  // Prevent stale UI: hide bottom buttons first, then apply cache/network config.
  ctx.dispatch(MyAssetActionCreator.onUpdateBottomButtonsVisibility(
    showInvestmentDetailButton: false,
    showWalletButton: false,
    pageFieldConfigs: const [],
  ));

  _preparePageFieldConfig(ctx).whenComplete(() {
    ctx.dispatch(MyAssetActionCreator.onLoadData());
  });
}

void _onDispose(Action action, Context<MyAssetState> ctx) {
  _refreshMyAssetSub?.cancel();
  _refreshMyAssetSub = null;
}

Future<void> _preparePageFieldConfig(Context<MyAssetState> ctx) async {
  var configList = ctx.state.cardDetail?.pageFieldConfig ?? [];

  if (configList.isEmpty) {
    final latestUid = await LocalStorage.getCardUuid();
    final detailUid = ctx.state.cardDetail?.uid;
    final keyCandidates = <String>{
      if (ctx.state.uid.isNotEmpty) ctx.state.uid,
      if (latestUid != null && latestUid.isNotEmpty) latestUid,
      if (detailUid != null && detailUid.isNotEmpty) detailUid,
    };

    String? cacheJson;
    String? hitKey;
    for (final uid in keyCandidates) {
      final key = LocalStorage.pageFieldConfig + uid;
      final value = await LocalStorage.getString(key);
      print('[PageFieldConfigCache] read key=$key, len=${value?.length ?? 0}');
      if (value?.isNotEmpty ?? false) {
        cacheJson = value;
        hitKey = key;
        break;
      }
    }
    if (hitKey != null) {
      print('[PageFieldConfigCache] hit key=$hitKey');
    }

    if (cacheJson?.isNotEmpty ?? false) {
      try {
        final dynamic decoded = jsonDecode(cacheJson!);
        if (decoded is List) {
          configList = decoded
              .map((e) {
                if (e is Map<String, dynamic>) {
                  return PageFieldConfig.fromJson(e);
                }
                if (e is String) {
                  return PageFieldConfig.fromJson(
                      jsonDecode(e) as Map<String, dynamic>);
                }
                return null;
              })
              .whereType<PageFieldConfig>()
              .toList();
        }
      } catch (_) {
        // Ignore broken cache and keep default visibility.
      }
    }
  } else {
    await LocalStorage.saveString(
      LocalStorage.pageFieldConfig + ctx.state.uid,
      jsonEncode(configList.map((e) => e.toJson()).toList()),
    );
  }

  ctx.state.pageFieldConfigs = configList;
  _applyBottomActionVisibility(ctx, configList);
}

void _applyBottomActionVisibility(
    Context<MyAssetState> ctx, List<PageFieldConfig> configList) {
  bool showInvestmentDetailButton = false;
  bool showWalletButton = false;

  if (configList.isEmpty) {
    ctx.dispatch(MyAssetActionCreator.onUpdateBottomButtonsVisibility(
      showInvestmentDetailButton: showInvestmentDetailButton,
      showWalletButton: showWalletButton,
      pageFieldConfigs: configList,
    ));
    return;
  }

  final codes = configList
      .map((e) => _normalizeFieldCode(e.fieldCode ?? ''))
      .where((e) => e.isNotEmpty)
      .toSet();

  showInvestmentDetailButton = codes.contains('investment_detail');
  showWalletButton = codes.contains('wallet');

  ctx.dispatch(MyAssetActionCreator.onUpdateBottomButtonsVisibility(
    showInvestmentDetailButton: showInvestmentDetailButton,
    showWalletButton: showWalletButton,
    pageFieldConfigs: configList,
  ));
}

String _normalizeFieldCode(String raw) {
  final code = raw.trim().toLowerCase();
  if (code.startsWith('#sym:')) {
    return code.substring(5);
  }
  return code;
}

Future<void> _onloadData(Action action, Context<MyAssetState> ctx) async {
  final completer = action.payload is Completer<void>
      ? action.payload as Completer<void>
      : null;

  await _preparePageFieldConfig(ctx);

  Map<String, dynamic> params = {
    "uid": ctx.state.uid,
  };
  LogUtils.uid = ctx.state.uid;

  try {
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
  } finally {
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }
}

Future<void> _onPushWalletClick(
    Action action, Context<MyAssetState> ctx) async {
  String cardId = ctx.state.uid.toUpperCase();

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
  String cardId = ctx.state.uid.toUpperCase();
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
