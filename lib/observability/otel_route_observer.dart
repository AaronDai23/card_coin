import 'package:card_coin/observability/otel_service.dart';
import 'package:flutter/widgets.dart';
import 'package:opentelemetry/api.dart';

class OtelRouteObserver extends NavigatorObserver {
  final Map<Route<dynamic>, Span> _activeSpans = <Route<dynamic>, Span>{};

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _startRouteSpan(route, 'push');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _finishRouteSpan(route, 'pop');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _finishRouteSpan(oldRoute, 'replace.old');
    }
    if (newRoute != null) {
      _startRouteSpan(newRoute, 'replace.new');
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _finishRouteSpan(route, 'remove');
    super.didRemove(route, previousRoute);
  }

  void _startRouteSpan(Route<dynamic> route, String navEvent) {
    final routeName = _routeName(route);
    final span = OtelService.instance.startSpan(
      'route.$routeName',
      kind: SpanKind.internal,
      attributes: [
        Attribute.fromString('route.name', routeName),
        Attribute.fromString('navigation.event', navEvent),
      ],
    );
    _activeSpans[route] = span;
  }

  void _finishRouteSpan(Route<dynamic> route, String navEvent) {
    final span = _activeSpans.remove(route);
    if (span == null) {
      return;
    }
    span
      ..setAttribute(Attribute.fromString('navigation.end_event', navEvent))
      ..end();
  }

  String _routeName(Route<dynamic> route) {
    final settingsName = route.settings.name;
    if (settingsName != null && settingsName.isNotEmpty) {
      return settingsName;
    }
    return route.runtimeType.toString();
  }
}
