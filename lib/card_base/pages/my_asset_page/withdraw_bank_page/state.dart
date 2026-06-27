import 'package:fish_redux/fish_redux.dart';

// ── 绑定的银行卡信息 ──────────────────────────────────────────
class WithdrawBankInfo {
  final bool bound;
  final String id;
  final String bankCode;
  final String bankName;
  final String cardNoMask;
  final String bankCardHolder;

  WithdrawBankInfo({
    required this.bound,
    this.id = '',
    this.bankCode = '',
    this.bankName = '',
    this.cardNoMask = '',
    this.bankCardHolder = '',
  });

  factory WithdrawBankInfo.fromJson(Map<String, dynamic> json) {
    return WithdrawBankInfo(
      bound: json['bound'] == true,
      id: json['id']?.toString() ?? '',
      bankCode: json['bankCode']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      cardNoMask: json['cardNoMask']?.toString() ?? '',
      bankCardHolder: json['bankCardHolder']?.toString() ?? '',
    );
  }
}

// ── 银行列表项 ────────────────────────────────────────────────
class BankItem {
  final String bankCode;
  final String bankName;
  final String logoUrl;

  BankItem({
    required this.bankCode,
    required this.bankName,
    required this.logoUrl,
  });

  factory BankItem.fromJson(Map<String, dynamic> json) {
    return BankItem(
      bankCode: json['bankCode']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? '',
    );
  }
}

class WithdrawBankState implements Cloneable<WithdrawBankState> {
  bool isEdit = false; // true = 修改，false = 首次绑定

  List<BankItem> bankList = [];
  String selectedBankCode = '';
  String selectedBankName = '';
  String cardHolder = '';
  String cardNo = '';

  bool isLoadingBanks = false;
  bool isSubmitting = false;

  @override
  WithdrawBankState clone() {
    return WithdrawBankState()
      ..isEdit = isEdit
      ..bankList = bankList
      ..selectedBankCode = selectedBankCode
      ..selectedBankName = selectedBankName
      ..cardHolder = cardHolder
      ..cardNo = cardNo
      ..isLoadingBanks = isLoadingBanks
      ..isSubmitting = isSubmitting;
  }
}

WithdrawBankState initState(Map<String, dynamic>? args) {
  final bound = args?['bound'] == true;
  final bankInfo = args?['bankInfo'] as WithdrawBankInfo?;
  return WithdrawBankState()
    ..isEdit = bound
    ..selectedBankCode = (bound && bankInfo != null) ? bankInfo.bankCode : ''
    ..selectedBankName = (bound && bankInfo != null) ? bankInfo.bankName : ''
    ..cardHolder = (bound && bankInfo != null) ? bankInfo.bankCardHolder : ''
    ..cardNo = (bound && bankInfo != null) ? bankInfo.cardNoMask : '';
}
