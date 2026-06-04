import 'dart:ui';

import 'package:card_coin/global_store/states/app_language_resource.dart';

import '../../../bean/blockchain/bit_coin_transaction_info.dart';
import '../../../global_store/state.dart';
import '../../../widget/base_page_loading.dart';

/// 内存缓存：按 cardId 缓存货币列表，同一会话内复用
final Map<String, List<CurrencyInfo>> _cachedCurrencyLists = {};

List<CurrencyInfo> _buildFallbackCurrencyList() {
  return [
    CurrencyInfo(
        imageUrl: '',
        networkName: 'Bitcoin',
        currencyData: CurrencyData('btc', '', 'Bitcoin', 'BTC', 'BTC')),
    CurrencyInfo(
        imageUrl: '',
        networkName: 'Tron',
        currencyData: CurrencyData('tron', '', 'TRON', 'TRX', 'tron')),
  ];
}

List<CurrencyInfo>? getCachedCurrencyList(String cardId) =>
    _cachedCurrencyLists[cardId];

void cacheCurrencyList(String cardId, List<CurrencyInfo> list) {
  _cachedCurrencyLists[cardId] = list;
}

class ScanWalletState implements GlobalBaseState<ScanWalletState>, PageLoad {
  List<CurrencyInfo> defaultCurrencyList = [];
  late String cardId;
  bool needBTC = false;
  bool needShowInitStatus = false;

  @override
  ScanWalletState clone() {
    return ScanWalletState()
      ..errorMsg = errorMsg
      ..cardId = cardId
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..loadStatus = loadStatus
      ..needBTC = needBTC
      ..needShowInitStatus = needShowInitStatus
      ..defaultCurrencyList = defaultCurrencyList;
  }

  @override
  String errorMsg = '';

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;
}

ScanWalletState initState(Map<String, dynamic>? args) {
  String cardId = args!['cardId'];
  bool needShowInitStatus = false;
  needShowInitStatus = args['needShowInitStatus'] ?? false;
  final cached = getCachedCurrencyList(cardId);
  return ScanWalletState()
    ..cardId = cardId
    ..needShowInitStatus = needShowInitStatus
    ..loadStatus = LoadType.loadSuccess
    ..defaultCurrencyList = cached ?? _buildFallbackCurrencyList()
    ..needBTC = true;
}
