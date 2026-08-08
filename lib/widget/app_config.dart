import 'package:flutter/cupertino.dart';

///
/// appInternalId
/// {
/// 'AirChip3':1,
/// 'AirChip3 Pro':2,
/// }
///

enum AppType{
  lite,
  pro,
  googleLite,
  bestWish
}

class AppConfig extends InheritedWidget {
  AppConfig(
      {super.key, required this.appDisplayName,
      required this.appInternalId,
        required this.stringResource,
      required Widget child})
      : super(child: child) {
    // Dio interceptors / early startup may run before Navigator has a context.
    current = this;
  }

  /// Last configured app flavor. Safe for non-widget callers (e.g. interceptors).
  static AppConfig? current;

  final String appDisplayName;
  final AppType appInternalId;
  final StringResource stringResource;

  bool get isProApp => appInternalId == AppType.pro;

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

abstract class StringResource {
  late String baseUrl;
  late String marketCode;
  late String signature;
}
