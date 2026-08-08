import 'package:card_coin/observability/firebase_analytics_service.dart';
import 'package:flutter/widgets.dart';

/// Automatic `screen_view` for Navigator push/pop/replace.
/// Tab switches that do not push routes must call
/// [FirebaseAnalyticsService.logScreen] separately.
class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _log(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _log(previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  void _log(Route<dynamic> route) {
    if (route is! PageRoute) return;
    final name = route.settings.name;
    if (name == null || name.isEmpty) return;
    // Ignore deep-link raw URLs / synthetic paths.
    if (name.startsWith('http://') ||
        name.startsWith('https://') ||
        name.startsWith('/')) {
      return;
    }
    FirebaseAnalyticsService.instance.logScreen(name);
  }
}

final AnalyticsRouteObserver analyticsRouteObserver = AnalyticsRouteObserver();
