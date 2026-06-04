import 'dart:async';
import 'dart:convert';

import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/pages/main_page/tab_pages/tab_wallet_page/my_card_page/action.dart';
import 'package:card_coin/card_base/utils/file_util.dart';
import 'package:card_coin/card_base/utils/routes_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:oktoast/oktoast.dart';

import '../../../../../custom_widget/progress_dialog/progress_dialog.dart';
import '../../../../../http/address.dart';
import '../../../../../http/http_manager.dart';
import '../../../../bean/banner_bean.dart';
import '../../../../bean/post_card_info.dart';
import '../../../settings_page/card_manager_page/action.dart';
import '../../action.dart';
import 'action.dart';
import 'state.dart';

const String pageSize = '20';
const String _kWalletBannerCacheKey = 'tab_wallet_banner_cache_v1';

Effect<TabWalletState>? buildEffect() {
  return combineEffects(<Object, Effect<TabWalletState>>{
    TabWalletAction.loadData: _onLoadData,
    CardManagerAction.deleteItem: _onInit,
    Lifecycle.initState: _onInit,
    TabWalletAction.setCardAmount: _onSetCardAmount,
    MainAction.updateUnReadCount: _onUpdateUnReadCount,
    TabWalletAction.bannerItemClick: _onBannerItemClick,
    MyCardAction.changeBgcolorInReTap: _onChangeBgColor
  });
}

void _onInit(Action action, Context<TabWalletState> ctx) {
  ctx.dispatch(TabWalletActionCreator.onLoadData());
}

Future<void> _onUpdateUnReadCount(
    Action action, Context<TabWalletState> ctx) async {
  ctx.dispatch(TabWalletActionCreator.onUpdateUnReadCount(action.payload));
}

void _onBannerItemClick(Action action, Context<TabWalletState> ctx) {
  BannerItem bannerItem = action.payload;
  RoutesUtil.pushName(bannerItem.target ?? '',
      type: bannerItem.type ?? '',
      needToken: bannerItem.token ?? false,
      title: bannerItem.name ?? '',
      content: bannerItem.description ?? '');
}

Future<void> _onChangeBgColor(
    Action action, Context<TabWalletState> ctx) async {
  bool isWhite = action.payload == true ? true : false;
  ctx.state.bgColor =
      isWhite ? Colors.white : const Color.fromARGB(255, 225, 240, 255);
  ctx.dispatch(TabWalletActionCreator.onLoadSuccess(ctx.state.banners!));
}

Future<void> _onLoadData(Action action, Context<TabWalletState> ctx) async {
  final fallbackBanners = ctx.state.banners ?? buildFallbackWalletBanners();

  // 1. 并行：读本地文件 + 读 banner 缓存（均为本地操作）
  final localFuture = FileUtil.getMapFromFile('post_card_source.json');
  final cacheFuture = LocalStorage.getString(_kWalletBannerCacheKey);
  final networkFuture = HttpManager.getInstance()
      .get(NetworkAddress.cardsBannerUrl, queryParameters: {});

  final postCardSource = await localFuture;
  final List postCardList = postCardSource['data'] as List;
  final typeList = postCardList
      .map((e) => CardCreateType.fromJson(e as Map<String, dynamic>))
      .toList();
  ctx.state.enableNfcCreate = typeList.any((element) => element.code == 'NFC');
  ctx.state.typeList = typeList;

  // 2. 有缓存 → 立即渲染，banner 秒出
  final cachedJson = await cacheFuture;
  if (cachedJson != null) {
    try {
      final List rawList = jsonDecode(cachedJson) as List;
      final cachedBanners = rawList
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList();
      if (cachedBanners.isNotEmpty) {
        ctx.dispatch(TabWalletActionCreator.onLoadSuccess(cachedBanners));
      }
    } catch (_) {}
  }

  // 3. 等网络结果（已在后台并行请求）
  final bannerResult = await networkFuture;
  if (bannerResult.isSuccess) {
    final remoteBanners = BannerResponse.fromJson(bannerResult.data).items;
    final banners = (remoteBanners != null && remoteBanners.isNotEmpty)
        ? remoteBanners
        : fallbackBanners;
    // 更新缓存
    unawaited(LocalStorage.saveString(_kWalletBannerCacheKey,
        jsonEncode(banners.map((e) => e.toJson()).toList())));
    ctx.dispatch(TabWalletActionCreator.onLoadSuccess(banners));
  } else if (cachedJson == null) {
    // 无缓存且网络失败 → 用 fallback，1s 后重试
    ctx.dispatch(TabWalletActionCreator.onLoadSuccess(fallbackBanners));
    Future.delayed(const Duration(seconds: 1), () {
      ctx.broadcast(TabWalletActionCreator.onReloadMainData());
    });
  }
}

Future<void> _onSetCardAmount(
    Action action, Context<TabWalletState> ctx) async {
  String id = action.payload['id'];
  int amount = action.payload['amount'];
  Map<String, dynamic> params = {'id': id, 'amount': amount};
  ProgressDialog pr = ProgressDialog(ctx.context);
  await pr.show();
  HttpManager.getInstance()
      .post(NetworkAddress.setCardAmountUrl, null, data: params)
      .then((result) {
    pr.hide();
    if (result.isSuccess) {
      ctx.dispatch(TabWalletActionCreator.onUpdateCardInfo(id, amount));
    } else {
      showToast(result.message);
    }
  });
}
