class InvestmentBalance {
  String? balance;
  String? code;
  String? imageUrl;
  String? name;
  String? symbol;
  String? price;
  String? usdDisplayAmount;

  InvestmentBalance(
      {this.balance,
      this.code,
      this.imageUrl,
      this.name,
      this.symbol,
      this.usdDisplayAmount,
      this.price});

  factory InvestmentBalance.fromJson(Map<String, dynamic> json) {
    return InvestmentBalance(
      balance: json['balance'],
      code: json['code'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      symbol: json['symbol'],
      price: json['price'],
      usdDisplayAmount: json['usdDisplayAmount'],
    );
  }
}
