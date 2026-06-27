import 'package:fish_redux/fish_redux.dart';

class ConvertHistoryItem {
  final String exchangeOrderId;
  final String fromCode;
  final String toCode;
  final String fromAmount;
  final String toAmount;
  final String status;
  final String createdAt;

  ConvertHistoryItem({
    required this.exchangeOrderId,
    required this.fromCode,
    required this.toCode,
    required this.fromAmount,
    required this.toAmount,
    required this.status,
    required this.createdAt,
  });

  factory ConvertHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConvertHistoryItem(
      exchangeOrderId: json['exchangeOrderId']?.toString() ?? '',
      fromCode: json['fromCode']?.toString() ?? '',
      toCode: json['toCode']?.toString() ?? '',
      fromAmount: json['fromAmount']?.toString() ?? '',
      toAmount: json['toAmount']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class ConvertHistoryState implements Cloneable<ConvertHistoryState> {
  String uid;
  List<ConvertHistoryItem> rows;
  int page;
  int total;
  bool isLoading;
  bool hasMore;

  ConvertHistoryState({
    required this.uid,
    this.rows = const [],
    this.page = 1,
    this.total = 0,
    this.isLoading = false,
    this.hasMore = true,
  });

  @override
  ConvertHistoryState clone() {
    return ConvertHistoryState(
      uid: uid,
      rows: List.from(rows),
      page: page,
      total: total,
      isLoading: isLoading,
      hasMore: hasMore,
    );
  }
}

ConvertHistoryState initState(Map<String, dynamic>? args) {
  return ConvertHistoryState(
    uid: args?['uid']?.toString() ?? '',
  );
}
