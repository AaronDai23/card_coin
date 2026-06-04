class TaskDetailInfo {
  final double amount;
  final String amountDirection;
  final String amountType;
  final String amountTypeFullName;
  final String amountTypeName;
  final String createBy;
  final int createTime;
  final String customerId;
  final String customerName;
  final String id;
  final String orgId;
  final String receiveBy;
  String receiveStatus;
  final String receiveStatusName;
  final String refId;
  final String status;
  final String statusName;
  final String unit;
  final String updateBy;
  final int updateTime;

  TaskDetailInfo({
    required this.amount,
    required this.amountDirection,
    required this.amountType,
    required this.amountTypeFullName,
    required this.amountTypeName,
    required this.createBy,
    required this.createTime,
    required this.customerId,
    required this.customerName,
    required this.id,
    required this.orgId,
    required this.receiveBy,
    required this.receiveStatus,
    required this.receiveStatusName,
    required this.refId,
    required this.status,
    required this.statusName,
    required this.unit,
    required this.updateBy,
    required this.updateTime,
  });

  factory TaskDetailInfo.fromJson(Map<String, dynamic> json) {
    return TaskDetailInfo(
      amount: json['amount'],
      amountDirection: json['amountDirection'],
      amountType: json['amountType'],
      amountTypeFullName: json['amountTypeFullName'],
      amountTypeName: json['amountTypeName'],
      createBy: json['createBy'],
      createTime: json['createTime'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      id: json['id'],
      orgId: json['orgId'],
      receiveBy: json['receiveBy'],
      receiveStatus: json['receiveStatus'],
      receiveStatusName: json['receiveStatusName'],
      refId: json['refId'],
      status: json['status'],
      statusName: json['statusName'],
      unit: json['unit'],
      updateBy: json['updateBy'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'amountDirection': amountDirection,
      'amountType': amountType,
      'amountTypeFullName': amountTypeFullName,
      'amountTypeName': amountTypeName,
      'createBy': createBy,
      'createTime': createTime,
      'customerId': customerId,
      'customerName': customerName,
      'id': id,
      'orgId': orgId,
      'receiveBy': receiveBy,
      'receiveStatus': receiveStatus,
      'receiveStatusName': receiveStatusName,
      'refId': refId,
      'status': status,
      'statusName': statusName,
      'unit': unit,
      'updateBy': updateBy,
      'updateTime': updateTime,
    };
  }
}
