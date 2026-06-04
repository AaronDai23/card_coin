class PointsHistoryInfo {
  int? total;
  List<PointsHistory>? rows;

  PointsHistoryInfo({this.total, this.rows});

  PointsHistoryInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = <PointsHistory>[];
      json['rows'].forEach((v) {
        rows!.add(PointsHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PointsHistory {
  num? accountBalance;
  late num amount;
  String? amountDirection;
  String? amountType;
  String? amountTypeFullName;
  String? amountTypeName;
  num? benefitsAmount;
  String? benefitsId;
  int? count;
  String? createBy;
  int? createTime;
  num? currentBalance;
  String? customerId;
  String? customerName;
  String? email;
  int? historyOrderCount;
  String? id;
  String? isoCode;
  String? levelName;
  String? nickName;
  String? orderId;
  String? orgId;
  int? overdueCount;
  double? payAmount;
  String? payGateway;
  String? phone;
  double? refAmount;
  String? refId;
  String? remarks;
  String? status;
  String? statusName;
  String? symbol;
  String? updateBy;
  int? updateTime;
  String? xeroBillId;
  bool? xeroBillPaid;
  String? xeroNegativeBillId;

  PointsHistory(
      {this.accountBalance,
      this.amount = 0,
      this.amountDirection,
      this.amountType,
      this.amountTypeFullName,
      this.amountTypeName,
      this.benefitsAmount,
      this.benefitsId,
      this.count,
      this.createBy,
      this.createTime,
      this.currentBalance,
      this.customerId,
      this.customerName,
      this.email,
      this.historyOrderCount,
      this.id,
      this.isoCode,
      this.levelName,
      this.nickName,
      this.orderId,
      this.orgId,
      this.overdueCount,
      this.payAmount,
      this.payGateway,
      this.phone,
      this.refAmount,
      this.refId,
      this.remarks,
      this.status,
      this.statusName,
      this.symbol,
      this.updateBy,
      this.updateTime,
      this.xeroBillId,
      this.xeroBillPaid,
      this.xeroNegativeBillId});

  PointsHistory.fromJson(Map<String, dynamic> json) {
    accountBalance = json['accountBalance'];
    amount = json['amount'];
    amountDirection = json['amountDirection'];
    amountType = json['amountType'];
    amountTypeFullName = json['amountTypeFullName'];
    amountTypeName = json['amountTypeName'];
    benefitsAmount = json['benefitsAmount'];
    benefitsId = json['benefitsId'];
    count = json['count'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    currentBalance = json['currentBalance'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    email = json['email'];
    historyOrderCount = json['historyOrderCount'];
    id = json['id'];
    isoCode = json['isoCode'];
    levelName = json['levelName'];
    nickName = json['nickName'];
    orderId = json['orderId'];
    orgId = json['orgId'];
    overdueCount = json['overdueCount'];
    payAmount = json['payAmount'];
    payGateway = json['payGateway'];
    phone = json['phone'];
    refAmount = json['refAmount'];
    refId = json['refId'];
    remarks = json['remarks'];
    status = json['status'];
    statusName = json['statusName'];
    symbol = json['symbol'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    xeroBillId = json['xeroBillId'];
    xeroBillPaid = json['xeroBillPaid'];
    xeroNegativeBillId = json['xeroNegativeBillId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountBalance'] = accountBalance;
    data['amount'] = amount;
    data['amountDirection'] = amountDirection;
    data['amountType'] = amountType;
    data['amountTypeFullName'] = amountTypeFullName;
    data['amountTypeName'] = amountTypeName;
    data['benefitsAmount'] = benefitsAmount;
    data['benefitsId'] = benefitsId;
    data['count'] = count;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['currentBalance'] = currentBalance;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['email'] = email;
    data['historyOrderCount'] = historyOrderCount;
    data['id'] = id;
    data['isoCode'] = isoCode;
    data['levelName'] = levelName;
    data['nickName'] = nickName;
    data['orderId'] = orderId;
    data['orgId'] = orgId;
    data['overdueCount'] = overdueCount;
    data['payAmount'] = payAmount;
    data['payGateway'] = payGateway;
    data['phone'] = phone;
    data['refAmount'] = refAmount;
    data['refId'] = refId;
    data['remarks'] = remarks;
    data['status'] = status;
    data['statusName'] = statusName;
    data['symbol'] = symbol;
    data['updateBy'] = updateBy;
    data['updateTime'] = updateTime;
    data['xeroBillId'] = xeroBillId;
    data['xeroBillPaid'] = xeroBillPaid;
    data['xeroNegativeBillId'] = xeroNegativeBillId;
    return data;
  }
}
