import 'package:card_coin/card_base/bean/investment_single_balance.dart';

class InvestmentSingleInfo {
  String? id;
  String? name;
  String? status;
  String? statusName;
  String? uid;
  InvestmentSingleBalance? investmentBalance;

  InvestmentSingleInfo({
    required this.id,
    required this.name,
    required this.status,
    required this.statusName,
    required this.uid,
    required this.investmentBalance,
  });

  factory InvestmentSingleInfo.fromJson(Map<String, dynamic> json) {
    InvestmentSingleBalance? investmentBalance;
    if (json['investmentBalance'] != null) {
      investmentBalance =
          InvestmentSingleBalance.fromJson(json['investmentBalance']);
    }
    return InvestmentSingleInfo(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      statusName: json['statusName'],
      uid: json['uid'],
      investmentBalance: investmentBalance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'statusName': statusName,
      'uid': uid,
      'investmentBalance': investmentBalance?.toJson(),
    };
  }
}
