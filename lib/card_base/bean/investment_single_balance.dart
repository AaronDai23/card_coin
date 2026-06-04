
class InvestmentSingleBalance {
  String? assetFromAddress;
  String? assetFromBalance;
  String? assetFromCode;
  String? assetFromImageUrl;
  String? assetFromName;
  String? assetFromPrice;
  String? assetFromUsd;
  String? assetFromUsdDisplayAmount;

  String? assetToAddress;
  String? assetToBalance;
  String? assetToCode;
  String? assetToImageUrl;
  String? assetToName;
  String? assetToPrice;
  String? assetToUsd;
  String? assetToUsdDisplayAmount;

  String? totalUsdDisplayAmount;

  InvestmentSingleBalance({
    this.assetFromAddress,
    this.assetFromBalance,
    this.assetFromCode,
    this.assetFromImageUrl,
    this.assetFromName,
    this.assetFromPrice,
    this.assetFromUsd,
    this.assetFromUsdDisplayAmount,
    this.assetToAddress,
    this.assetToBalance,
    this.assetToCode,
    this.assetToImageUrl,
    this.assetToName,
    this.assetToPrice,
    this.assetToUsd,
    this.assetToUsdDisplayAmount,
    this.totalUsdDisplayAmount,
  });

  factory InvestmentSingleBalance.fromJson(Map<String, dynamic> json) {
    return InvestmentSingleBalance(
        assetFromAddress: json['assetFromAddress'],
        assetFromBalance: json['assetFromBalance'],
        assetFromCode: json['assetFromCode'],
        assetFromImageUrl: json['assetFromImageUrl'],
        assetFromName: json['assetFromName'],
        assetFromPrice: json['assetFromPrice'],
        assetFromUsd: json['assetFromUsd'],
        assetFromUsdDisplayAmount: json['assetFromUsdDisplayAmount'],
        assetToAddress: json['assetToAddress'],
        assetToBalance: json['assetToBalance'],
        assetToCode: json['assetToCode'],
        assetToImageUrl: json['assetToImageUrl'],
        assetToName: json['assetToName'],
        assetToPrice: json['assetToPrice'],
        assetToUsd: json['assetToUsd'],
        assetToUsdDisplayAmount: json['assetToUsdDisplayAmount'],
        totalUsdDisplayAmount: json['totalUsdDisplayAmount'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'assetFromAddress': assetFromAddress,
      'assetFromBalance': assetFromBalance,
      'assetFromCode': assetFromCode,
      'assetFromImageUrl': assetFromImageUrl,
      'assetFromName': assetFromName,
      'assetFromPrice': assetFromPrice,
      'assetFromUsd': assetFromUsd,
      'assetFromUsdDisplayAmount': assetFromUsdDisplayAmount,
      'assetToAddress': assetToAddress,
      'assetToBalance': assetToBalance,
      'assetToCode': assetToCode,
      'assetToImageUrl': assetToImageUrl,
      'assetToName': assetToName,
      'assetToPrice': assetToPrice,
      'assetToUsd': assetToUsd,
      'assetToUsdDisplayAmount': assetToUsdDisplayAmount,
      'totalUsdDisplayAmount': totalUsdDisplayAmount ?? "",
    };
  }
}
