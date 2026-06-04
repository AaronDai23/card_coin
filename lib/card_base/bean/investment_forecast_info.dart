class InvestmentForecastInfo {
  String? acquisitionAmount;
  String? acquisitionUnit;
  String? investmentAmount;
  String? acquisitionImageUrl;
  int? investmentNumber;
  int? investmentTimestamp;
  String? investmentTime;
  String? price;

  InvestmentForecastInfo(
      {this.acquisitionAmount,
      this.acquisitionUnit,
      this.investmentAmount,
      this.investmentNumber,
      this.investmentTime,
      this.price,
      this.acquisitionImageUrl,
      this.investmentTimestamp});

  factory InvestmentForecastInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentForecastInfo(
      acquisitionAmount: json['acquisitionAmount'],
      acquisitionUnit: json['acquisitionUnit'],
      investmentAmount: json['investmentAmount'],
      investmentNumber: json['investmentNumber'],
      investmentTime: json['investmentTime'],
      price: json['price'],
      acquisitionImageUrl: json['acquisitionImageUrl'],
      investmentTimestamp: json['investmentTimestamp'],
    );
  }
}
