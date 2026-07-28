import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/card_base/bean/banner_bean.dart';
import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:card_coin/card_base/pages/scan_login_page/state.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Prefetch ScanLogin banners/buttons during Splash so first open feels warm.
class ScanLoginPrefetch {
  ScanLoginPrefetch._();

  static const bannerCacheKey = 'scan_login_banner_cache_v1';
  static const buttonCacheKey = 'scan_login_button_cache_v1';

  static Future<void>? _inFlight;
  static bool _hasHttpBannersReady = false;

  static bool get hasHttpBannersReady => _hasHttpBannersReady;

  /// Fire-and-forget from Splash; safe to call multiple times.
  static Future<void> start({BuildContext? context}) {
    return _inFlight ??= _run(context: context).whenComplete(() {
      // Allow a later refresh after first success/failure.
      Future<void>.delayed(const Duration(seconds: 2), () {
        _inFlight = null;
      });
    });
  }

  /// Wait up to [timeout] for first http banners (and image warm if possible).
  static Future<void> waitReady({
    Duration timeout = const Duration(milliseconds: 1200),
  }) async {
    if (_hasHttpBannersReady) return;
    final pending = _inFlight ?? start();
    try {
      await pending.timeout(timeout);
    } on TimeoutException {
      // Navigate anyway — ScanLogin will keep loading.
    } catch (_) {}
  }

  static Future<void> _run({BuildContext? context}) async {
    var banners = <BannerItem>[];
    var buttons = <PageCategoryItem>[];

    // 1) Disk cache first for instant memory warm.
    try {
      final cached = await Future.wait([
        LocalStorage.getString(bannerCacheKey),
        LocalStorage.getString(buttonCacheKey),
      ]);
      banners = _parseBanners(cached[0]);
      buttons = _parseButtons(cached[1]);
      if (banners.isNotEmpty || buttons.isNotEmpty) {
        cacheScanLoginData(
          banners.isNotEmpty ? banners : buildFallbackBanners(),
          buttons,
        );
        if (_isHttp(banners)) {
          _hasHttpBannersReady = true;
          await _warmImages(banners, context: context);
        }
      }
    } catch (_) {}

    // 2) Network refresh.
    try {
      final results = await Future.wait([
        HttpManager.getInstance()
            .get(NetworkAddress.homeBannerUrl, queryParameters: const {}),
        HttpManager.getInstance()
            .get(NetworkAddress.pageCategoryUrl, queryParameters: const {}),
      ]);

      final bannerResult = results[0];
      final buttonResult = results[1];

      if (bannerResult.isSuccess) {
        final remote = BannerResponse.fromJson(bannerResult.data).items;
        if (remote != null && remote.isNotEmpty) {
          banners = remote;
        }
      }

      if (buttonResult.isSuccess && buttonResult.data is List<dynamic>) {
        buttons = (buttonResult.data as List<dynamic>)
            .map((e) => PageCategoryItem.fromJson(e))
            .toList();
      }

      if (banners.isNotEmpty) {
        cacheScanLoginData(banners, buttons);
        unawaited(LocalStorage.saveString(
          bannerCacheKey,
          json.encode(banners.map((e) => e.toJson()).toList()),
        ));
        if (_isHttp(banners)) {
          _hasHttpBannersReady = true;
          await _warmImages(banners, context: context);
        }
      }
      if (buttonResult.isSuccess) {
        unawaited(LocalStorage.saveString(
          buttonCacheKey,
          json.encode(buttons.map((e) => e.toJson()).toList()),
        ));
      }
    } catch (e) {
      print('[ScanLoginPrefetch] failed: $e');
    }
  }

  static bool _isHttp(List<BannerItem> banners) {
    if (banners.isEmpty) return false;
    final url = banners.first.fileUrl?.trim() ?? '';
    return url.startsWith('http');
  }

  static Future<void> _warmImages(
    List<BannerItem> banners, {
    BuildContext? context,
  }) async {
    final urls = banners
        .map((e) => e.fileUrl?.trim())
        .whereType<String>()
        .where((u) => u.startsWith('http'))
        .toList();
    if (urls.isEmpty) return;

    // Disk warm first (no BuildContext needed) — critical for first open.
    await Future.wait(urls.map((url) async {
      try {
        await DefaultCacheManager().downloadFile(url);
      } catch (_) {}
    }));

    final ctx = context;
    if (ctx == null || !ctx.mounted) return;
    for (final url in urls) {
      try {
        await precacheImage(CachedNetworkImageProvider(url), ctx);
      } catch (_) {}
    }
  }

  static List<BannerItem> _parseBanners(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = json.decode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(BannerItem.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static List<PageCategoryItem> _parseButtons(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = json.decode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(PageCategoryItem.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
