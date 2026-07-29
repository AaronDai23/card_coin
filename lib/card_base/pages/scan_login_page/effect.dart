import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart' hide Action;
import '../../../cache/local_storage.dart';
import 'package:fish_redux/fish_redux.dart';
import '../../../utils/startup_time.dart';
import '../../../http/address.dart';
import '../../../http/http_manager.dart';
import '../../bean/banner_bean.dart';
import '../../bean/page_categroy_item.dart';
import '../../utils/routes_util.dart';
import 'action.dart';
import 'scan_login_prefetch.dart';
import 'state.dart';

Effect<ScanLoginState>? buildEffect() {
  return combineEffects(<Object, Effect<ScanLoginState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDisponse,
    ScanLoginAction.buttonItemClick: _onButtonItemClick,
    ScanLoginAction.bannerItemClick: _onBannerItemClick,
    ScanLoginAction.loadData: _onloadData,
  });
}

Future<void> _onInit(Action action, Context<ScanLoginState> ctx) async {
  StartupTime.printElapsed('scan_login_init');
  // Keep splash logo briefly so route handoff stays seamless, then skeleton.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        try {
          ctx.dispatch(ScanLoginActionCreator.onEndSplashLogoBridge());
        } catch (_) {}
      });
    });
  });
  // Splash may already have warmed memory/disk; sync UI from memory immediately.
  unawaited(_restoreScanLoginCache(ctx));
  ctx.dispatch(ScanLoginActionCreator.onLoadData());
}

Future<void> _onBannerItemClick(
    Action action, Context<ScanLoginState> ctx) async {
  BannerItem bannerItem = action.payload;
  print('banner click: ${bannerItem.name}');
  if (bannerItem.type != null && bannerItem.type != 'NONE') {
    RoutesUtil.pushName(bannerItem.target!,
        type: bannerItem.type!,
        title: bannerItem.name ?? '',
        content: bannerItem.content ?? '');
  }
}

void _onButtonItemClick(Action action, Context<ScanLoginState> ctx) {
  PageCategoryItem buttonItem = action.payload;

  if (buttonItem.target == 'scanCard') {
    if (!ctx.state.isScanning) {
      ctx.dispatch(ScanLoginActionCreator.onStartNFC());
    }
  } else {
    String targetName = buttonItem.target ?? '';
    String type = buttonItem.type ?? '';
    String title = buttonItem.name ?? '';
    RoutesUtil.pushName(targetName, type: type, title: title);
  }
}

void _onDisponse(Action action, Context<ScanLoginState> ctx) async {
  ctx.state.timer?.cancel();
  ctx.state.controller.dispose();
}

void _prefetchBannerImages(BuildContext context, List<BannerItem> banners) {
  for (final item in banners) {
    final url = item.fileUrl?.trim();
    if (url == null || !url.startsWith('http')) continue;
    unawaited(precacheImage(CachedNetworkImageProvider(url), context));
  }
}

void _publishScanLogin(
  Context<ScanLoginState> ctx, {
  required List<BannerItem> banners,
  required List<PageCategoryItem> buttons,
  required bool persistBanners,
  required bool persistButtons,
}) {
  final enableLogin =
      buttons.any((element) => element.target == 'multipleLoginPage');
  ctx.state.showLoginButton = !enableLogin;
  cacheScanLoginData(banners, buttons);
  _prefetchBannerImages(ctx.context, banners);

  if (persistBanners && banners.isNotEmpty) {
    unawaited(LocalStorage.saveString(ScanLoginPrefetch.bannerCacheKey,
        json.encode(banners.map((e) => e.toJson()).toList())));
  }
  if (persistButtons) {
    unawaited(LocalStorage.saveString(ScanLoginPrefetch.buttonCacheKey,
        json.encode(buttons.map((e) => e.toJson()).toList())));
  }

  ctx.dispatch(ScanLoginActionCreator.onLoadSuccess(banners, buttons));
}

Future<void> _onloadData(Action action, Context<ScanLoginState> ctx) async {
  // If Splash already finished prefetch, memory cache is ready — refresh in bg.
  if (ScanLoginPrefetch.hasHttpBannersReady &&
      _cachedHasHttp(ctx.state.banners)) {
    // Still refresh network in background via shared prefetcher.
    unawaited(ScanLoginPrefetch.start(context: ctx.context).then((_) {
      final banners = peekCachedScanLoginBanners();
      final buttons = peekCachedScanLoginButtons();
      if (banners != null && buttons != null) {
        _publishScanLogin(
          ctx,
          banners: banners,
          buttons: buttons,
          persistBanners: false,
          persistButtons: false,
        );
      }
    }));
    return;
  }

  var banners = ctx.state.banners ?? buildFallbackBanners();
  var buttons = ctx.state.buttons ?? buildFallbackButtons();
  bool buttonRequestFailed = false;
  bool buttonRequestSuccess = false;

  Map<String, dynamic> params = {};
  final bannerFuture = HttpManager.getInstance()
      .get(NetworkAddress.homeBannerUrl, queryParameters: params);
  final buttonFuture = HttpManager.getInstance()
      .get(NetworkAddress.pageCategoryUrl, queryParameters: params);

  try {
    var bannerResult = await bannerFuture;
    if (bannerResult.isSuccess) {
      final remoteBanners = BannerResponse.fromJson(bannerResult.data).items;
      if (remoteBanners != null && remoteBanners.isNotEmpty) {
        banners = remoteBanners;
        _publishScanLogin(
          ctx,
          banners: banners,
          buttons: buttons,
          persistBanners: true,
          persistButtons: false,
        );
      }
    }
  } catch (e) {
    print('scan_login banner load failed: $e');
  }

  try {
    var buttonResult = await buttonFuture;
    if (buttonResult.isSuccess) {
      buttonRequestSuccess = true;
      final buttonData = buttonResult.data;
      if (buttonData is List<dynamic>) {
        final list =
            buttonData.map((e) => PageCategoryItem.fromJson(e)).toList();
        buttons = list;
      }
    } else {
      buttonRequestFailed = true;
    }
  } catch (e) {
    buttonRequestFailed = true;
    print('scan_login button load failed: $e');
  }

  if (buttonRequestFailed && buttons.isEmpty) {
    buttons = buildFailureFallbackButtons();
  }

  _publishScanLogin(
    ctx,
    banners: banners,
    buttons: buttons,
    persistBanners: true,
    persistButtons: buttonRequestSuccess,
  );
}

bool _cachedHasHttp(List<BannerItem>? banners) {
  if (banners == null || banners.isEmpty) return false;
  return (banners.first.fileUrl?.trim() ?? '').startsWith('http');
}

Future<void> _restoreScanLoginCache(Context<ScanLoginState> ctx) async {
  final results = await Future.wait([
    LocalStorage.getString(ScanLoginPrefetch.bannerCacheKey),
    LocalStorage.getString(ScanLoginPrefetch.buttonCacheKey),
  ]);

  final cachedBanners = _parseBannerList(results[0]);
  final cachedButtons = _parseButtonList(results[1]);

  final mergedBanners =
      cachedBanners.isNotEmpty ? cachedBanners : ctx.state.banners;
  final mergedButtons =
      cachedButtons.isNotEmpty ? cachedButtons : ctx.state.buttons;

  if ((cachedBanners.isNotEmpty || cachedButtons.isNotEmpty) &&
      mergedBanners != null &&
      mergedButtons != null) {
    _publishScanLogin(
      ctx,
      banners: mergedBanners,
      buttons: mergedButtons,
      persistBanners: false,
      persistButtons: false,
    );
  }
}

List<BannerItem> _parseBannerList(String? raw) {
  if (raw == null || raw.isEmpty) {
    return [];
  }
  try {
    final decoded = json.decode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => BannerItem.fromJson(e))
          .toList();
    }
  } catch (_) {}
  return [];
}

List<PageCategoryItem> _parseButtonList(String? raw) {
  if (raw == null || raw.isEmpty) {
    return [];
  }
  try {
    final decoded = json.decode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => PageCategoryItem.fromJson(e))
          .toList();
    }
  } catch (_) {}
  return [];
}
