import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Minimal Firebase Analytics (GA4) for iOS + Android.
///
/// Usage:
/// - Page coverage: [analyticsRouteObserver] (wired on MaterialApp)
/// - Tab / dialogs: [logScreen]
/// - UI clicks: [logClick]
/// - Funnels: [logBiz]
class FirebaseAnalyticsService {
  FirebaseAnalyticsService._();

  static final FirebaseAnalyticsService instance = FirebaseAnalyticsService._();

  bool _ready = false;
  String? _currentScreen;

  bool get isReady => _ready;

  String? get currentScreen => _currentScreen;

  FirebaseAnalytics? get _analytics =>
      _ready ? FirebaseAnalytics.instance : null;

  Future<void> init() async {
    if (_ready) return;
    if (kIsWeb) return;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      // Helps confirm init in logcat / Flutter console when DebugView is empty.
      if (kDebugMode) {
        await FirebaseAnalytics.instance.setSessionTimeoutDuration(
          const Duration(minutes: 30),
        );
      }
      await FirebaseAnalytics.instance.logAppOpen();
      _ready = true;
      developer.log('[Analytics] Firebase Analytics ready', name: 'analytics');
      // ignore: avoid_print
      print('[Analytics] ready — enable DebugView with: '
          'adb shell setprop debug.firebase.analytics.app com.cardcoin.bestwish');
    } catch (e, st) {
      _ready = false;
      developer.log(
        '[Analytics] init skipped (add GoogleService config): $e',
        name: 'analytics',
        stackTrace: st,
      );
    }
  }

  /// Screen / tab exposure. Prefer route names already used by the app
  /// (`splashPage`, `tabWalletPage`, …).
  Future<void> logScreen(
    String name, {
    String? fromScreen,
    Map<String, Object>? parameters,
  }) async {
    final screen = _sanitizeName(name, fallback: 'unknown_screen');
    final analytics = _analytics;
    if (analytics == null) return;

    final from = fromScreen ?? _currentScreen;
    _currentScreen = screen;

    try {
      await analytics.logScreenView(
        screenName: screen,
        parameters: <String, Object>{
          if (from != null && from.isNotEmpty) 'from_screen': from,
          ...?parameters,
        },
      );
    } catch (e) {
      developer.log('[Analytics] logScreen($screen) failed: $e',
          name: 'analytics');
    }
  }

  /// Lightweight UI interaction (button / menu). Keep sparse.
  Future<void> logClick(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await logEvent(
      'click_${_sanitizeName(name, fallback: 'unknown')}',
      parameters: {
        if (_currentScreen != null) 'screen': _currentScreen!,
        ...?parameters,
      },
    );
  }

  /// Business / conversion events (`login_success`, `write_card_success`, …).
  Future<void> logBiz(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await logEvent(
      _sanitizeName(name, fallback: 'biz_event'),
      parameters: {
        if (_currentScreen != null) 'screen': _currentScreen!,
        ...?parameters,
      },
    );
  }

  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    final analytics = _analytics;
    if (analytics == null) return;
    final event = _sanitizeName(name, fallback: 'event');
    try {
      await analytics.logEvent(name: event, parameters: parameters);
    } catch (e) {
      developer.log('[Analytics] logEvent($event) failed: $e',
          name: 'analytics');
    }
  }

  Future<void> setUserId(String? id) async {
    final analytics = _analytics;
    if (analytics == null) return;
    try {
      await analytics.setUserId(id: id);
    } catch (e) {
      developer.log('[Analytics] setUserId failed: $e', name: 'analytics');
    }
  }

  Future<void> logLogin({String? method}) async {
    await logBiz(
      'login_success',
      parameters: {
        if (method != null && method.isNotEmpty) 'method': method,
      },
    );
  }

  /// GA4: names must start with a letter, only [a-zA-Z0-9_], max 40 chars.
  static String _sanitizeName(String raw, {required String fallback}) {
    var s = raw.trim();
    if (s.isEmpty) return fallback;
    s = s.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (!RegExp(r'^[a-zA-Z]').hasMatch(s)) {
      s = 'e_$s';
    }
    if (s.length > 40) {
      s = s.substring(0, 40);
    }
    return s;
  }
}
