import 'package:card_coin/card_base/bean/Investment_forecast_info.dart';

class InvestmentForecast {
  String? totalInvestment;
  String? acquisitionUnit;
  String? totalAcquisition;
  String? totalValue;
  String? totalRevenue;
  String? earningRate;
  String? price;
  String? direction;
  String? averagePrice;
  String? name;
  int? investmentCount;
  List<InvestmentForecastInfo>? investments = [];

  InvestmentForecast({
    this.totalInvestment,
    this.acquisitionUnit,
    this.totalAcquisition,
    this.totalValue,
    this.totalRevenue,
    this.earningRate,
    this.price,
    this.direction,
    this.investments,
    this.investmentCount,
    this.averagePrice,
    this.name,
  });

  InvestmentForecast.fromJson(Map<String, dynamic> json) {
    totalInvestment = json['totalInvestment'];
    acquisitionUnit = json['acquisitionUnit'];
    totalAcquisition = json['totalAcquisition'];
    totalValue = json['totalValue'];
    totalRevenue = json['totalRevenue'];
    earningRate = json['earningRate'];
    price = json['price'];
    direction = json['direction'];
    averagePrice = json['averagePrice'];
    investmentCount = json['investmentCount'];
    name = json['name'];
    if (json['investments'] != null) {
      investments = <InvestmentForecastInfo>[];
      json['investments'].forEach((v) {
        investments!.add(InvestmentForecastInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInvestment': totalInvestment,
      'acquisitionUnit': acquisitionUnit,
      'totalAcquisition': totalAcquisition,
      'totalValue': totalValue,
      'totalRevenue': totalRevenue,
      'earningRate': earningRate,
      'price': price,
      'direction': direction,
      'investmentCount': investmentCount,
      'averagePrice': averagePrice,
      'name': name,
      'investments': investments.toString(),
    };
  }
}
