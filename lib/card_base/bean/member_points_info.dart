import 'package:card_coin/utils/number_util.dart';

class MemberPointsInfo {
  late String currentBalance;
  late String currentBalanceAround;
  late num exchangeCount;
  String? imageUrl;
  String? imageUrlAround;
  late num incomeCount;
  String? name;
  late int scale;
  String? symbol;
  String? symbolAround;
  late num totalExchange;
  late num totalExchangeAround;
  late String totalIncome;
  late String totalIncomeAround;
  late String yesterdayIncome;
  late String yesterdayIncomeAround;

  MemberPointsInfo(
      {this.currentBalance = '0',
        this.currentBalanceAround = '0',
        this.exchangeCount = 0,
        this.imageUrl,
        this.imageUrlAround,
        this.incomeCount = 0,
        this.name,
        this.scale = 0,
        this.symbol,
        this.symbolAround,
        this.totalExchange = 0,
        this.totalExchangeAround = 0,
        this.totalIncome = '0',
        this.totalIncomeAround = '0',
        this.yesterdayIncome = '0',
        this.yesterdayIncomeAround = '0'});

  MemberPointsInfo.fromJson(Map<String, dynamic> json) {
    scale = json['scale'];

    currentBalance = NumberUtils.formatNumber(json['currentBalance'],scale);
    currentBalanceAround = NumberUtils.formatNumber(json['currentBalance'],scale);
    exchangeCount = json['exchangeCount'];
    imageUrl = json['imageUrl'];
    imageUrlAround = json['imageUrlAround'];
    incomeCount = json['incomeCount'];
    name = json['name'];

    symbol = json['symbol'];
    symbolAround = json['symbolAround'];
    totalExchange = json['totalExchange'];
    totalExchangeAround = json['totalExchangeAround'];
    totalIncome = NumberUtils.formatNumber(json['totalIncome'],scale);
    totalIncomeAround = NumberUtils.formatNumber(json['totalIncomeAround'],scale);
    yesterdayIncome = NumberUtils.formatNumber(json['yesterdayIncome'],scale);
    yesterdayIncomeAround = NumberUtils.formatNumber(json['yesterdayIncomeAround'],scale);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentBalance'] = currentBalance;
    data['currentBalanceAround'] = currentBalanceAround;
    data['exchangeCount'] = exchangeCount;
    data['imageUrl'] = imageUrl;
    data['imageUrlAround'] = imageUrlAround;
    data['incomeCount'] = incomeCount;
    data['name'] = name;
    data['scale'] = scale;
    data['symbol'] = symbol;
    data['symbolAround'] = symbolAround;
    data['totalExchange'] = totalExchange;
    data['totalExchangeAround'] = totalExchangeAround;
    data['totalIncome'] = totalIncome;
    data['totalIncomeAround'] = totalIncomeAround;
    data['yesterdayIncome'] = yesterdayIncome;
    data['yesterdayIncomeAround'] = yesterdayIncomeAround;
    return data;
  }
}
