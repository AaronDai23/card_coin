import 'package:fish_redux/fish_redux.dart';

class CashOutDetailTimeline {
  final String code;
  final String label;
  final String? at;

  CashOutDetailTimeline({
    required this.code,
    required this.label,
    this.at,
  });

  factory CashOutDetailTimeline.fromJson(Map<String, dynamic> json) {
    return CashOutDetailTimeline(
      code: json['code']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      at: json['at']?.toString(),
    );
  }
}

class CashOutDetailInfo {
  final String cashOutAuditId;
  final String symbol;
  final String amount;
  final String fee;
  final String status;
  final String bankName;
  final String cardNoMask;
  final String bankCardHolder;
  final List<CashOutDetailTimeline> timeline;

  CashOutDetailInfo({
    required this.cashOutAuditId,
    required this.symbol,
    required this.amount,
    required this.fee,
    required this.status,
    required this.bankName,
    required this.cardNoMask,
    required this.bankCardHolder,
    required this.timeline,
  });

  factory CashOutDetailInfo.fromJson(Map<String, dynamic> json) {
    final rawTimeline = json['timeline'];
    final timeline = rawTimeline is List
        ? rawTimeline
            .map((e) =>
                CashOutDetailTimeline.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CashOutDetailTimeline>[];
    return CashOutDetailInfo(
      cashOutAuditId: json['cashOutAuditId']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      fee: json['fee']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      cardNoMask: json['cardNoMask']?.toString() ?? '',
      bankCardHolder: json['bankCardHolder']?.toString() ?? '',
      timeline: timeline,
    );
  }
}

class CashOutDetailState implements Cloneable<CashOutDetailState> {
  String uid;
  String cashOutAuditId;
  CashOutDetailInfo? detail;
  bool isLoading;

  CashOutDetailState({
    required this.uid,
    required this.cashOutAuditId,
    this.detail,
    this.isLoading = false,
  });

  @override
  CashOutDetailState clone() {
    return CashOutDetailState(
      uid: uid,
      cashOutAuditId: cashOutAuditId,
      detail: detail,
      isLoading: isLoading,
    );
  }
}

CashOutDetailState initState(Map<String, dynamic>? args) {
  return CashOutDetailState(
    uid: args?['uid']?.toString() ?? '',
    cashOutAuditId: args?['cashOutAuditId']?.toString() ?? '',
  );
}
