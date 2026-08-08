import 'package:appsflyer_sdk/appsflyer_sdk.dart';

/// Safe wrapper: [AppsflyerSdk(null)] asserts when the SDK was never started
/// (e.g. splash skipped due to missing DEV_KEY / invalid iOS APP_ID).
class AppsFlyerSafe {
  AppsFlyerSafe._();

  static AppsflyerSdk? _sdk;

  static void bind(AppsflyerSdk sdk) {
    _sdk = sdk;
  }

  static Future<void> logEvent(
    String name, [
    Map? values,
  ]) async {
    final sdk = _sdk;
    if (sdk == null) return;
    try {
      await sdk.logEvent(name, values);
    } catch (_) {
      // Attribution must never break product flows.
    }
  }
}
