import 'package:fish_redux/fish_redux.dart';

class ConvertDetailStep {
  final String code;
  final String label;
  final String status;
  final String? at;

  ConvertDetailStep({
    required this.code,
    required this.label,
    required this.status,
    this.at,
  });

  factory ConvertDetailStep.fromJson(Map<String, dynamic> json) {
    return ConvertDetailStep(
      code: json['code']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      at: json['at']?.toString(),
    );
  }
}

class ConvertDetailInfo {
  final String exchangeOrderId;
  final String status;
  final String fromCode;
  final String toCode;
  final String fromAmount;
  final String requestedToAmount;
  final String actualToAmount;
  final String fee;
  final String feeSymbol;
  final String rate;
  final String txHash;
  final String errorMessage;
  final String createdAt;
  final String signedAt;
  final String onChainAt;
  final String gatewayAt;
  final String fiatCreditedAt;
  final List<ConvertDetailStep> steps;
  final Map<String, dynamic> chain;

  ConvertDetailInfo({
    required this.exchangeOrderId,
    required this.status,
    required this.fromCode,
    required this.toCode,
    required this.fromAmount,
    required this.requestedToAmount,
    required this.actualToAmount,
    required this.fee,
    required this.feeSymbol,
    required this.rate,
    required this.txHash,
    required this.errorMessage,
    required this.createdAt,
    required this.signedAt,
    required this.onChainAt,
    required this.gatewayAt,
    required this.fiatCreditedAt,
    required this.steps,
    required this.chain,
  });

  factory ConvertDetailInfo.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'];
    final steps = rawSteps is List
        ? rawSteps
            .map((e) => ConvertDetailStep.fromJson(e as Map<String, dynamic>))
            .toList()
        : <ConvertDetailStep>[];

    final rawChain = json['chain'];

    return ConvertDetailInfo(
      exchangeOrderId: json['exchangeOrderId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fromCode: json['fromCode']?.toString() ?? '',
      toCode: json['toCode']?.toString() ?? '',
      fromAmount: json['fromAmount']?.toString() ?? '',
      requestedToAmount: json['requestedToAmount']?.toString() ?? '',
      actualToAmount: json['actualToAmount']?.toString() ?? '',
      fee: json['fee']?.toString() ?? '',
      feeSymbol: json['feeSymbol']?.toString() ?? '',
      rate: json['rate']?.toString() ?? '',
      txHash: json['txHash']?.toString() ?? '',
      errorMessage: json['errorMessage']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      signedAt: json['signedAt']?.toString() ?? '',
      onChainAt: json['onChainAt']?.toString() ?? '',
      gatewayAt: json['gatewayAt']?.toString() ?? '',
      fiatCreditedAt: json['fiatCreditedAt']?.toString() ?? '',
      steps: steps,
      chain: rawChain is Map<String, dynamic>
          ? Map<String, dynamic>.from(rawChain)
          : <String, dynamic>{},
    );
  }
}

class ConvertDetailState implements Cloneable<ConvertDetailState> {
  String uid;
  String exchangeOrderId;
  ConvertDetailInfo? detail;
  bool isLoading;

  ConvertDetailState({
    required this.uid,
    required this.exchangeOrderId,
    this.detail,
    this.isLoading = false,
  });

  @override
  ConvertDetailState clone() {
    return ConvertDetailState(
      uid: uid,
      exchangeOrderId: exchangeOrderId,
      detail: detail,
      isLoading: isLoading,
    );
  }
}

ConvertDetailState initState(Map<String, dynamic>? args) {
  return ConvertDetailState(
    uid: args?['uid']?.toString() ?? '',
    exchangeOrderId: args?['exchangeOrderId']?.toString() ?? '',
  );
}
