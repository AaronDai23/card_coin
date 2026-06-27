import 'package:fish_redux/fish_redux.dart';

import '../withdraw_bank_page/state.dart';

export '../withdraw_bank_page/state.dart' show WithdrawBankInfo;

// ── 手续费试算响应 ──────────────────────────────────────────────
class CashOutFeeInfo {
  final String symbol;
  final String amount;
  final String fee;
  final String totalDeduct;
  final String availableBalance;
  final bool canCashOut;

  CashOutFeeInfo({
    required this.symbol,
    required this.amount,
    required this.fee,
    required this.totalDeduct,
    required this.availableBalance,
    required this.canCashOut,
  });

  factory CashOutFeeInfo.fromJson(Map<String, dynamic> json) {
    return CashOutFeeInfo(
      symbol: json['symbol']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      fee: json['fee']?.toString() ?? '',
      totalDeduct: json['totalDeduct']?.toString() ?? '',
      availableBalance: json['availableBalance']?.toString() ?? '',
      canCashOut: json['canCashOut'] == true,
    );
  }
}

class CashOutState implements Cloneable<CashOutState> {
  String uid = '';
  String symbol = ''; // 法币 code（如 IDR）
  String balance = ''; // 可用余额（初始来自资产摘要，fee API 返回后更新）

  // ── 输入金额 ──────────────────────────────────────
  String inputAmount = '';

  // ── 银行卡信息 ─────────────────────────────────────
  WithdrawBankInfo? bankInfo;
  bool isLoadingBank = false;

  // ── 手续费 ────────────────────────────────────────
  CashOutFeeInfo? feeInfo;
  bool isLoadingFee = false;

  // ── 提交 ──────────────────────────────────────────
  bool isSubmitting = false;

  @override
  CashOutState clone() {
    return CashOutState()
      ..uid = uid
      ..symbol = symbol
      ..balance = balance
      ..inputAmount = inputAmount
      ..bankInfo = bankInfo
      ..isLoadingBank = isLoadingBank
      ..feeInfo = feeInfo
      ..isLoadingFee = isLoadingFee
      ..isSubmitting = isSubmitting;
  }
}

CashOutState initState(Map<String, dynamic>? args) {
  return CashOutState()
    ..uid = args?['uid']?.toString() ?? ''
    ..symbol = args?['symbol']?.toString() ?? ''
    ..balance = args?['balance']?.toString() ?? '';
}
