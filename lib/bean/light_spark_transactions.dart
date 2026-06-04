class LightSparkTransactions {
  late String amountUnit;
  late String amountValue;
  late String primaryAmount;
  late String primaryUnit;
  int? createTime;

  late String statusName;
  late String amountDirection;
  late String amountTypeName;
  late String remarks;

  LightSparkTransactions({required this.amountUnit, required this.amountValue});

  LightSparkTransactions.fromJson(Map<String, dynamic> json) {
    amountUnit = json['unit'];
    amountValue = json['amount'];
    createTime = json['createTime'];
    primaryAmount = json['primaryAmount'];
    primaryUnit = json['primaryUnit'];
    statusName = json['statusName'];
    amountDirection = json['amountDirection'];
    amountTypeName = json['amountTypeName'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountUnit'] = amountUnit;
    data['amountValue'] = amountValue;
    data['createTime'] = createTime;
    data['primaryAmount'] = primaryAmount;
    data['primaryUnit'] = primaryUnit;
    data['statusName'] = statusName;
    data['amountDirection'] = amountDirection;
    data['amountTypeName'] = amountTypeName;
    data['remarks'] = remarks;
    return data;
  }
}
