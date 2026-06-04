class InvestmentItemInfo {
  String? balance;
  String? symbol;

  InvestmentItemInfo({this.balance, this.symbol});

  InvestmentItemInfo.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'symbol': symbol,
    };
  }
}
