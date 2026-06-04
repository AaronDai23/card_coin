class InvestmentHistoryInfo {
  String? assetFrom;
  String? assetFromAmount;
  String? assetFromType;
  String? assetTo;
  String? assetToAddress;
  String? assetToAmount;
  String? assetToNetwork;
  String? assetToType;
  String? createBy;
  int? createTime;
  String? id;
  String? intervalExtend1;
  String? intervalExtend2;
  String? intervalExtend3;
  String? intervalType;
  String? intervalTypeName;
  String? jobId;
  String? name;
  String? orderId;
  String? orgId;
  int? periods;
  String? provider;
  String? remarks;
  String? status;
  String? statusName;
  String? triggerName;
  String? uid;
  String? updateBy;
  int? updateTime;
  String? withdrawId;

  InvestmentHistoryInfo({
    this.assetFrom,
    this.assetFromAmount,
    this.assetFromType,
    this.assetTo,
    this.assetToAddress,
    this.assetToAmount,
    this.assetToNetwork,
    this.assetToType,
    this.createBy,
    this.createTime,
    this.id,
    this.intervalExtend1,
    this.intervalExtend2,
    this.intervalExtend3,
    this.intervalType,
    this.intervalTypeName,
    this.jobId,
    this.name,
    this.orderId,
    this.orgId,
    this.periods,
    this.provider,
    this.remarks,
    this.status,
    this.statusName,
    this.triggerName,
    this.uid,
    this.updateBy,
    this.updateTime,
    this.withdrawId,
  });

  factory InvestmentHistoryInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentHistoryInfo(
      assetFrom: json['assetFrom'],
      assetFromAmount: json['assetFromAmount'],
      assetFromType: json['assetFromType'],
      assetTo: json['assetTo'],
      assetToAddress: json['assetToAddress'],
      assetToAmount: json['assetToAmount'],
      assetToNetwork: json['assetToNetwork'],
      assetToType: json['assetToType'],
      createBy: json['createBy'],
      createTime: json['createTime'],
      id: json['id'],
      intervalExtend1: json['intervalExtend1'],
      intervalExtend2: json['intervalExtend2'],
      intervalExtend3: json['intervalExtend3'],
      intervalType: json['intervalType'],
      intervalTypeName: json['intervalTypeName'],
      jobId: json['jobId'],
      name: json['name'],
      orderId: json['orderId'],
      orgId: json['orgId'],
      periods: json['periods'],
      provider: json['provider'],
      remarks: json['remarks'],
      status: json['status'],
      statusName: json['statusName'],
      triggerName: json['triggerName'],
      uid: json['uid'],
      updateBy: json['updateBy'],
      updateTime: json['updateTime'],
      withdrawId: json['withdrawId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetFrom': assetFrom,
      'assetFromAmount': assetFromAmount,
      'assetFromType': assetFromType,
      'assetTo': assetTo,
      'assetToAddress': assetToAddress,
      'assetToAmount': assetToAmount,
      'assetToNetwork': assetToNetwork,
      'assetToType': assetToType,
      'createBy': createBy,
      'createTime': createTime,
      'id': id,
      'intervalExtend1': intervalExtend1,
      'intervalExtend2': intervalExtend2,
      'intervalExtend3': intervalExtend3,
      'intervalType': intervalType,
      'intervalTypeName': intervalTypeName,
      'jobId': jobId,
      'name': name,
      'orderId': orderId,
      'orgId': orgId,
      'periods': periods,
      'provider': provider,
      'remarks': remarks,
      'status': status,
      'statusName': statusName,
      'triggerName': triggerName,
      'uid': uid,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'withdrawId': withdrawId,
    };
  }
}
