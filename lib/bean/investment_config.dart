class InvestmentConfig {
  bool? investmentCreation;
  bool? investmentUpdate;
  String? investmentAssetDestination = '';
  String? investmentFlow;

  InvestmentConfig({
    this.investmentCreation,
    this.investmentUpdate,
    this.investmentAssetDestination,
    this.investmentFlow,
  });

  factory InvestmentConfig.fromJson(Map<String, dynamic> json) {
    return InvestmentConfig(
      investmentCreation: json['investmentCreation'],
      investmentUpdate: json['investmentUpdate'],
      investmentAssetDestination: json['investmentAssetDestination'],
      investmentFlow: json['investmentFlow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investmentCreation': investmentCreation,
      'investmentUpdate': investmentUpdate,
      'investmentAssetDestination': investmentAssetDestination,
      'investmentFlow': investmentFlow,
    };
  }
}
