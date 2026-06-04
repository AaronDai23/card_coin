class SmartCardContractFlowItem {
  String? createBy;
  int? createTime;
  bool? delegatePayment;
  String? description;
  String? flowCode;
  String? flowCodeName;
  String? flowId;
  String? id;
  String? imageUrl;
  String? name;
  String? orgId;
  int? seq;
  String? status;
  String? statusName;
  String? updateBy;
  int? updateTime;

  SmartCardContractFlowItem(
      {this.createBy,
      this.createTime,
      this.delegatePayment,
      this.description,
      this.flowCode,
      this.flowCodeName,
      this.flowId,
      this.id,
      this.imageUrl,
      this.name,
      this.orgId,
      this.seq,
      this.status,
      this.statusName,
      this.updateBy,
      this.updateTime});

  factory SmartCardContractFlowItem.fromJson(Map<String, dynamic> json) {
    return SmartCardContractFlowItem(
        createBy: json['createBy'],
        createTime: json['createTime'],
        delegatePayment: json['delegatePayment'],
        description: json['description'],
        flowCode: json['flowCode'],
        flowCodeName: json['flowCodeName'],
        flowId: json['flowId'],
        id: json['id'],
        imageUrl: json['imageUrl'],
        name: json['name'],
        orgId: json['orgId'],
        seq: json['seq'],
        status: json['status'],
        statusName: json['statusName'],
        updateBy: json['updateBy'],
        updateTime: json['updateTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'createBy': createBy,
      'createTime': createTime,
      'delegatePayment': delegatePayment,
      'description': description,
      'flowCode': flowCode,
      'flowCodeName': flowCodeName,
      'flowId': flowId,
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'orgId': orgId,
      'seq': seq,
      'status': status,
      'statusName': statusName,
      'updateBy': updateBy,
      'updateTime': updateTime
    };
  }
}
