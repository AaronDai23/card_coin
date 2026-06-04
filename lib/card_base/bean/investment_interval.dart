import 'package:card_coin/card_base/bean/Investment_select_info.dart';

class InvestmentInterval {
  List<InvestmentSelectInfo>? intervalDay;
  List<InvestmentSelectInfo>? intervalHour;
  List<InvestmentSelectInfo>? intervalMinute;
  List<InvestmentSelectInfo>? intervalMonth;
  List<InvestmentSelectInfo>? intervalTime;
  List<InvestmentSelectInfo>? intervalUnit;
  List<InvestmentSelectInfo>? intervalWeek;

  InvestmentInterval({
    this.intervalDay,
    this.intervalHour,
    this.intervalMinute,
    this.intervalMonth,
    this.intervalTime,
    this.intervalUnit,
    this.intervalWeek,
  });

  factory InvestmentInterval.fromJson(Map<String, dynamic> json) {
    List<InvestmentSelectInfo>? intervalDay;
    if (json['intervalDay'] != null) {
      intervalDay = <InvestmentSelectInfo>[];
      json['intervalDay'].forEach((v) {
        intervalDay!.add(InvestmentSelectInfo.fromJson(v));
      });
    }

    List<InvestmentSelectInfo>? intervalHour;
    if (json['intervalHour'] != null) {
      intervalHour = <InvestmentSelectInfo>[];
      json['intervalHour'].forEach((v) {
        intervalHour!.add(InvestmentSelectInfo.fromJson(v));
      });
    }
    List<InvestmentSelectInfo>? intervalMinute;
    if (json['intervalMinute'] != null) {
      intervalMinute = <InvestmentSelectInfo>[];
      json['intervalMinute'].forEach((v) {
        intervalMinute!.add(InvestmentSelectInfo.fromJson(v));
      });
    }

    List<InvestmentSelectInfo>? intervalMonth;
    if (json['intervalMonth'] != null) {
      intervalMonth = <InvestmentSelectInfo>[];
      json['intervalMonth'].forEach((v) {
        intervalMonth!.add(InvestmentSelectInfo.fromJson(v));
      });
    }

    List<InvestmentSelectInfo>? intervalTime;
    if (json['intervalTime'] != null) {
      intervalTime = <InvestmentSelectInfo>[];
      json['intervalTime'].forEach((v) {
        intervalTime!.add(InvestmentSelectInfo.fromJson(v));
      });
    }

    List<InvestmentSelectInfo>? intervalUnit;
    if (json['intervalUnit'] != null) {
      intervalUnit = <InvestmentSelectInfo>[];
      json['intervalUnit'].forEach((v) {
        intervalUnit!.add(InvestmentSelectInfo.fromJson(v));
      });
    }

    List<InvestmentSelectInfo>? intervalWeek;
    if (json['intervalWeek'] != null) {
      intervalWeek = <InvestmentSelectInfo>[];
      json['intervalWeek'].forEach((v) {
        intervalWeek!.add(InvestmentSelectInfo.fromJson(v));
      });
    }
    return InvestmentInterval(
        intervalDay: intervalDay,
        intervalHour: intervalHour,
        intervalMinute: intervalMinute,
        intervalMonth: intervalMonth,
        intervalTime: intervalTime,
        intervalUnit: intervalUnit,
        intervalWeek: intervalWeek);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (intervalDay != null) {
      data['intervalDay'] = intervalDay!.map((v) => v.toJson()).toList();
    }
    if (intervalHour != null) {
      data['intervalHour'] = intervalHour!.map((v) => v.toJson()).toList();
    }
    if (intervalMinute != null) {
      data['intervalMinute'] =
          intervalMinute!.map((v) => v.toJson()).toList();
    }
    if (intervalMonth != null) {
      data['intervalMonth'] =
          intervalMonth!.map((v) => v.toJson()).toList();
    }
    if (intervalTime != null) {
      data['intervalTime'] = intervalTime!.map((v) => v.toJson()).toList();
    }
    if (intervalUnit != null) {
      data['intervalUnit'] = intervalUnit!.map((v) => v.toJson()).toList();
    }
    if (intervalWeek != null) {
      data['intervalWeek'] = intervalWeek!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
