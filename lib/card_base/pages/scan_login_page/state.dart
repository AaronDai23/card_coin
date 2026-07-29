import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/banner_bean.dart';
import '../../bean/page_categroy_item.dart';

List<BannerItem>? _cachedScanLoginBanners;
List<PageCategoryItem>? _cachedScanLoginButtons;

class ScanLoginState extends LoadPageState<ScanLoginState> {
  late PageController controller;
  Timer? timer;
  List<BannerItem>? banners;
  List<PageCategoryItem>? buttons;
  bool isScanning = false;
  bool showLoginButton = false;
  /// False until first banner fetch/cache resolve — then skeleton/swiper.
  bool bannerFetchCompleted = false;
  /// First frames after splash: keep logo cover before skeleton/banner.
  bool splashLogoBridge = true;
  MethodChannel? channel;
  int counter = 0;
  @override
  ScanLoginState clone() {
    return ScanLoginState()
      ..banners = banners
      ..buttons = buttons
      ..isScanning = isScanning
      ..errorMsg = errorMsg
      ..showLoginButton = showLoginButton
      ..bannerFetchCompleted = bannerFetchCompleted
      ..splashLogoBridge = splashLogoBridge
      ..loadStatus = loadStatus
      ..timer = timer
      ..counter = counter
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..controller = controller
      ..channel = channel;
  }
}

List<BannerItem> buildFallbackBanners() {
  return [
    BannerItem(
      fileUrl: 'tap_banner_bg',
      name: 'Welcome',
      type: 'NONE',
    ),
  ];
}

List<PageCategoryItem> buildFallbackButtons() {
  return [];
}

List<PageCategoryItem> buildFailureFallbackButtons() {
  return [
    PageCategoryItem(
      name: 'Login',
      target: 'multipleLoginPage',
      type: 'PAGE',
    ),
  ];
}

bool _hasHttpBanners(List<BannerItem>? banners) {
  if (banners == null || banners.isEmpty) return false;
  final url = banners.first.fileUrl?.trim() ?? '';
  return url.startsWith('http');
}

ScanLoginState initState(Map<String, dynamic>? args) {
  final cachedBanners = _cachedScanLoginBanners;
  final cachedButtons = _cachedScanLoginButtons;
  final banners = (cachedBanners != null && cachedBanners.isNotEmpty)
      ? List<BannerItem>.from(cachedBanners)
      : buildFallbackBanners();
  return ScanLoginState()
    ..loadStatus = LoadType.loadSuccess
    ..banners = banners
    ..buttons = (cachedButtons != null && cachedButtons.isNotEmpty)
        ? List<PageCategoryItem>.from(cachedButtons)
        : buildFallbackButtons()
    ..bannerFetchCompleted = _hasHttpBanners(banners)
    ..splashLogoBridge = true
    ..controller = PageController();
}

List<BannerItem>? peekCachedScanLoginBanners() =>
    _cachedScanLoginBanners == null
        ? null
        : List<BannerItem>.from(_cachedScanLoginBanners!);

List<PageCategoryItem>? peekCachedScanLoginButtons() =>
    _cachedScanLoginButtons == null
        ? null
        : List<PageCategoryItem>.from(_cachedScanLoginButtons!);

void cacheScanLoginData(
    List<BannerItem> banners, List<PageCategoryItem> buttons) {
  _cachedScanLoginBanners = List<BannerItem>.from(banners);
  _cachedScanLoginButtons = List<PageCategoryItem>.from(buttons);
}
