import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/card_base/bean/investment_item_info.dart';

class InvestmentInfo {
  String? assetFrom;
  String? assetFromAmount;
  String? assetFromType;
  String? assetTo;
  String? assetToAddress;
  String? assetToNetwork;
  String? assetToType;
  String? createBy;
  int? createTime;
  String? intervalDescription;
  String? id;
  String? intervalExtend1;
  String? intervalExtend2;
  String? intervalExtend3;
  String? intervalExtend1Name;
  String? intervalExtend2Name;
  String? intervalExtend3Name;
  String? intervalType;
  String? intervalTypeName;
  String? name;
  String? orgId;
  int? periods;
  String? remarks;
  String? status;
  String? statusName;
  String? triggerName;
  String? uid;
  String? updateBy;
  int? updateTime;
  int? previousTriggerTime;
  String? smartCardCryptoId;
  String? assetToImageUrl;
  String? assetToName;
  int? executedCount;
  int? nextTriggerTime;
  InvestmentItemInfo? contractBalance;
  InvestmentConfig? investmentConfig;

  InvestmentInfo(
      {this.assetFrom,
      this.assetFromAmount,
      this.assetFromType,
      this.assetTo,
      this.assetToAddress,
      this.assetToNetwork,
      this.assetToType,
      this.createBy,
      this.createTime,
      this.id,
      this.intervalExtend1,
      this.intervalExtend2,
      this.intervalExtend3,
      this.intervalExtend1Name,
      this.intervalExtend2Name,
      this.intervalExtend3Name,
      this.intervalType,
      this.intervalTypeName,
      this.name,
      this.orgId,
      this.periods,
      this.remarks,
      this.status,
      this.statusName,
      this.triggerName,
      this.uid,
      this.updateBy,
      this.updateTime,
      this.smartCardCryptoId,
      this.previousTriggerTime,
      this.nextTriggerTime,
      this.assetToImageUrl,
      this.executedCount,
      this.assetToName,
      this.intervalDescription,
      this.contractBalance,
      this.investmentConfig});

  factory InvestmentInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentInfo(
      assetFrom: json['assetFrom'],
      assetFromAmount: json['assetFromAmount'],
      assetFromType: json['assetFromType'],
      assetTo: json['assetTo'],
      assetToAddress: json['assetToAddress'],
      assetToNetwork: json['assetToNetwork'],
      assetToType: json['assetToType'],
      createBy: json['createBy'],
      createTime: json['createTime'],
      id: json['id'],
      intervalExtend1: json['intervalExtend1'],
      intervalExtend2: json['intervalExtend2'],
      intervalExtend3: json['intervalExtend3'],
      intervalExtend1Name: json['intervalExtend1Name'],
      intervalExtend2Name: json['intervalExtend2Name'],
      intervalExtend3Name: json['intervalExtend3Name'],
      intervalType: json['intervalType'],
      intervalTypeName: json['intervalTypeName'],
      name: json['name'],
      orgId: json['orgId'],
      periods: json['periods'],
      remarks: json['remarks'],
      status: json['status'],
      statusName: json['statusName'],
      triggerName: json['triggerName'],
      uid: json['uid'],
      updateBy: json['updateBy'],
      updateTime: json['updateTime'],
      smartCardCryptoId: json['smartCardCryptoId'],
      previousTriggerTime: json['previousTriggerTime'],
      assetToImageUrl: json['assetToImageUrl'],
      executedCount: json['executedCount'],
      nextTriggerTime: json['nextTriggerTime'],
      assetToName: json['assetToName'],
      intervalDescription: json['intervalDescription'],
      contractBalance: json['contractBalance'] != null
          ? InvestmentItemInfo.fromJson(json['contractBalance'])
          : null,
      investmentConfig: json['investmentConfig'] != null
          ? InvestmentConfig.fromJson(json['investmentConfig'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetFrom': assetFrom,
      'assetFromAmount': assetFromAmount,
      'assetFromType': assetFromType,
      'assetTo': assetTo,
      'assetToAddress': assetToAddress,
      'assetToNetwork': assetToNetwork,
      'assetToType': assetToType,
      'createBy': createBy,
      'createTime': createTime,
      'id': id,
      'intervalExtend1': intervalExtend1,
      'intervalExtend2': intervalExtend2,
      'intervalExtend3': intervalExtend3,
      'intervalExtend1Name': intervalExtend1Name,
      'intervalExtend2Name': intervalExtend2Name,
      'intervalExtend3Name': intervalExtend3Name,
      'intervalType': intervalType,
      'intervalTypeName': intervalTypeName,
      'name': name,
      'orgId': orgId,
      'periods': periods,
      'remarks': remarks,
      'status': status,
      'statusName': statusName,
      'triggerName': triggerName,
      'uid': uid,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'smartCardCryptoId': smartCardCryptoId,
      'previousTriggerTime': previousTriggerTime,
      'nextTriggerTime': nextTriggerTime,
      'assetToImageUrl': assetToImageUrl,
      'executedCount': executedCount,
      'assetToName': assetToName,
      'intervalDescription': intervalDescription,
      'contractBalance': contractBalance?.toJson(),
      'investmentConfig': investmentConfig?.toJson(),
    };
  }
}
