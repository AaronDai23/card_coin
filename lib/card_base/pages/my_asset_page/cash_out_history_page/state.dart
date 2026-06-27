import 'package:fish_redux/fish_redux.dart';

class CashOutHistoryItem {
  final String cashOutAuditId;
  final String symbol;
  final String amount;
  final String fee;
  final String status;
  final String bankName;
  final String cardNoMask;
  final String submittedAt;
  final String completedAt;

  CashOutHistoryItem({
    required this.cashOutAuditId,
    required this.symbol,
    required this.amount,
    required this.fee,
    required this.status,
    required this.bankName,
    required this.cardNoMask,
    required this.submittedAt,
    required this.completedAt,
  });

  factory CashOutHistoryItem.fromJson(Map<String, dynamic> json) {
    return CashOutHistoryItem(
      cashOutAuditId: json['cashOutAuditId']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      fee: json['fee']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      cardNoMask: json['cardNoMask']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
    );
  }
}

class CashOutHistoryState implements Cloneable<CashOutHistoryState> {
  String uid;
  String symbol;
  List<CashOutHistoryItem> rows;
  int page;
  int total;
  bool isLoading;
  bool hasMore;

  CashOutHistoryState({
    required this.uid,
    required this.symbol,
    this.rows = const [],
    this.page = 1,
    this.total = 0,
    this.isLoading = false,
    this.hasMore = true,
  });

  @override
  CashOutHistoryState clone() {
    return CashOutHistoryState(
      uid: uid,
      symbol: symbol,
      rows: List.from(rows),
      page: page,
      total: total,
      isLoading: isLoading,
      hasMore: hasMore,
    );
  }
}

CashOutHistoryState initState(Map<String, dynamic>? args) {
  return CashOutHistoryState(
    uid: args?['uid']?.toString() ?? '',
    symbol: args?['symbol']?.toString() ?? '',
  );
}
