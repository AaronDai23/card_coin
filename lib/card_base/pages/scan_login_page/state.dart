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

ScanLoginState initState(Map<String, dynamic>? args) {
  final cachedBanners = _cachedScanLoginBanners;
  final cachedButtons = _cachedScanLoginButtons;
  return ScanLoginState()
    ..loadStatus = LoadType.loadSuccess
    ..banners = (cachedBanners != null && cachedBanners.isNotEmpty)
        ? List<BannerItem>.from(cachedBanners)
        : buildFallbackBanners()
    ..buttons = (cachedButtons != null && cachedButtons.isNotEmpty)
        ? List<PageCategoryItem>.from(cachedButtons)
        : buildFallbackButtons()
    ..controller = PageController();
}

void cacheScanLoginData(
    List<BannerItem> banners, List<PageCategoryItem> buttons) {
  _cachedScanLoginBanners = List<BannerItem>.from(banners);
  _cachedScanLoginButtons = List<PageCategoryItem>.from(buttons);
}
