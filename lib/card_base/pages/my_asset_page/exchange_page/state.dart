import 'package:fish_redux/fish_redux.dart';

// ── 来源货币（来自 /exchange/init） ────────────────────────────
class ExchangeFromItem {
  final String id;
  final String code;
  final String name;
  final String imageUrl;
  final String balance;
  final String networkCode;
  final String step;

  ExchangeFromItem({
    required this.id,
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.balance,
    required this.networkCode,
    required this.step,
  });

  factory ExchangeFromItem.fromJson(Map<String, dynamic> json) {
    return ExchangeFromItem(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      balance: json['balance']?.toString() ?? '',
      networkCode: json['networkCode']?.toString() ?? '',
      step: json['step']?.toString() ?? '1',
    );
  }
}

// ── 目标货币（来自 /exchange/target） ─────────────────────────
class ExchangeToItem {
  final String id;
  final String code;
  final String name;
  final String imageUrl;
  final String step;
  final String maxConvertible;

  ExchangeToItem({
    required this.id,
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.step,
    required this.maxConvertible,
  });

  factory ExchangeToItem.fromJson(Map<String, dynamic> json) {
    return ExchangeToItem(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      step: json['step']?.toString() ?? '1',
      maxConvertible: json['maxConvertible']?.toString() ?? '',
    );
  }
}

class ExchangeState implements Cloneable<ExchangeState> {
  String uid = '';

  // ── From (/exchange/init) ──────────────────────
  List<ExchangeFromItem> fromList = [];
  int selectedFromIndex = 0;
  bool isLoadingFrom = false;

  // ── To (/exchange/target) ─────────────────────
  List<ExchangeToItem> toList = [];
  int selectedToIndex = 0;
  bool isLoadingTo = false;

  // ── Rate (/exchange/price, 定时刷新) ───────────
  String rate = '';
  String rateUpdatedAt = '';
  bool isLoadingRate = false;

  // ── Amount ────────────────────────────────────
  String inputAmount = '';
  String estimatedToAmount = '';

  // ── Preview (/exchange/preview) ────────────────
  bool isLoadingPreview = false;
  String previewEstimated = '';   // estimatedToAmount（服务端预估到账）
  String previewFeeDisplay = '';  // "{fee} {feeSymbol}" 显示用
  String previewReceived = '';    // You get（同币种扣费后）

  // ── Submit ────────────────────────────────────
  bool isSubmitting = false;

  ExchangeFromItem? get selectedFrom =>
      fromList.isEmpty ? null : fromList[selectedFromIndex];

  ExchangeToItem? get selectedTo =>
      toList.isEmpty ? null : toList[selectedToIndex];

  @override
  ExchangeState clone() {
    return ExchangeState()
      ..uid = uid
      ..fromList = fromList
      ..selectedFromIndex = selectedFromIndex
      ..isLoadingFrom = isLoadingFrom
      ..toList = toList
      ..selectedToIndex = selectedToIndex
      ..isLoadingTo = isLoadingTo
      ..rate = rate
      ..rateUpdatedAt = rateUpdatedAt
      ..isLoadingRate = isLoadingRate
      ..inputAmount = inputAmount
      ..estimatedToAmount = estimatedToAmount
      ..isLoadingPreview = isLoadingPreview
      ..previewEstimated = previewEstimated
      ..previewFeeDisplay = previewFeeDisplay
      ..previewReceived = previewReceived
      ..isSubmitting = isSubmitting;
  }
}

ExchangeState initState(Map<String, dynamic>? args) {
  return ExchangeState()..uid = args?['uid']?.toString() ?? '';
}
