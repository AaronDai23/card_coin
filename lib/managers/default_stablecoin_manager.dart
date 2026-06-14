import 'package:card_coin/cache/local_storage.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';

class DefaultStablecoinManager {
  static const String fallbackStablecoin = 'USDT';

  static Future<void> refreshFromServer() async {
    try {
      final result = await HttpManager.getInstance().get(
        NetworkAddress.defaultStablecoin,
        noTip: true,
      );
      if (!result.isSuccess) return;

      final stablecoin = _extractStablecoin(result.data);
      if (stablecoin == null) return;

      await LocalStorage.saveDefaultStablecoin(stablecoin);
      print('[DefaultStablecoin] refreshed: $stablecoin');
    } catch (e) {
      // Non-blocking startup task: ignore failures to avoid impacting main flow.
      print('[DefaultStablecoin] refresh failed: $e');
    }
  }

  static Future<String> getCachedOrFallback() async {
    final cached = await LocalStorage.getDefaultStablecoin();
    final normalized = normalizeStablecoin(cached);
    if (normalized.isNotEmpty) return normalized;
    return fallbackStablecoin;
  }

  static String normalizeStablecoin(String? value) {
    final normalized = value?.trim().toUpperCase() ?? '';
    if (normalized.isEmpty) return '';
    return normalized;
  }

  static bool isUsdOrUsdt(String? value) {
    final normalized = normalizeStablecoin(value);
    return normalized == 'USD' || normalized == 'USDT';
  }

  static bool equalsIgnoreCase(String? left, String? right) {
    return normalizeStablecoin(left) == normalizeStablecoin(right);
  }

  static String? _extractStablecoin(dynamic data) {
    if (data is String) {
      final normalized = normalizeStablecoin(data);
      return normalized.isEmpty ? "USDT" : normalized;
    }

    if (data is Map) {
      const candidates = <String>[
        'string',
        'symbol',
        'unit',
        'currency',
        'code',
        'name',
        'defaultStablecoin',
      ];

      for (final key in candidates) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return normalizeStablecoin(value);
        }
      }

      for (final value in data.values) {
        if (value is String && value.trim().isNotEmpty) {
          return normalizeStablecoin(value);
        }
      }
    }

    return null;
  }
}
