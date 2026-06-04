import 'package:fl_chart/fl_chart.dart';

import 'card_info_bean.dart';

class InvestmentViewModel {
  final List<FlSpot> spotList;
  final double minY;
  final double maxY;
  final String previousPrice;
  final String averagePrice;
  final String? cardNo;
  final String? planName;
  final String? cardBalance;
  final String? amount;
  final String? maxPeriods;
  final String? cycleName;
  final String executeTime;
  final bool showKLine;
  final bool showCardNo;
  final bool showPlan;
  final bool showBalance;
  final bool showAmount;
  final bool showMaxPeriods;
  final bool showCycle;
  final SmartCardDetail? cardDetail;
  final List valueArr;

  InvestmentViewModel({
    required this.spotList,
    required this.minY,
    required this.maxY,
    required this.previousPrice,
    required this.averagePrice,
    required this.executeTime,
    this.cardNo,
    this.planName,
    this.cardBalance,
    this.amount,
    this.maxPeriods,
    this.cycleName,
    this.showKLine = false,
    this.showCardNo = false,
    this.showPlan = false,
    this.showBalance = false,
    this.showAmount = false,
    this.showMaxPeriods = false,
    this.showCycle = false,
    this.cardDetail,
    this.valueArr = const [0, 0],
  });
}
