import 'package:card_coin/card_base/bean/flow_transation_info.dart';

class FlowProgressInfo {
  String? approvalSignId;
  int? approvalTransactionCount;
  String? approvalTransactionHash;
  String? approvalTransactionResult;
  String? remarks;
  String? status;
  String? transferSignId;
  int? transferTransactionCount;
  String? transferTransactionHash;
  String? transferTransactionResult;
  FlowTransationInfo? approvalTransaction;
  FlowTransationInfo? transferTransaction;
  String? triggerName;
  String? type;
  String? uid;
  String? investmentId;

  FlowProgressInfo({
    this.approvalSignId,
    this.approvalTransactionCount,
    this.approvalTransactionHash,
    this.approvalTransactionResult,
    this.remarks,
    this.status,
    this.transferSignId,
    this.transferTransactionCount,
    this.transferTransactionHash,
    this.transferTransactionResult,
    this.triggerName,
    this.type,
    this.uid,
    this.approvalTransaction,
    this.transferTransaction,
    this.investmentId,
  });

  factory FlowProgressInfo.fromJson(Map<String, dynamic> json) {
    FlowTransationInfo? approvalTransaction;
    FlowTransationInfo? transferTransaction;

    if (json['approvalTransaction'] != null) {
      approvalTransaction =
          FlowTransationInfo.fromJson(json['approvalTransaction']);
    }
    if (json['transferTransaction'] != null) {
      transferTransaction =
          FlowTransationInfo.fromJson(json['transferTransaction']);
    }

    return FlowProgressInfo(
      approvalSignId: json['approvalSignId'],
      approvalTransactionCount: json['approvalTransactionCount'],
      approvalTransactionHash: json['approvalTransactionHash'],
      remarks: json['remarks'],
      status: json['status'],
      transferSignId: json['transferSignId'],
      transferTransactionCount: json['transferTransactionCount'],
      transferTransactionHash: json['transferTransactionHash'],
      approvalTransactionResult: json['approvalTransactionResult'],
      transferTransactionResult: json['transferTransactionResult'],
      triggerName: json['triggerName'],
      type: json['type'],
      uid: json['uid'],
      investmentId: json['investmentId'],
      approvalTransaction: approvalTransaction,
      transferTransaction: transferTransaction,
    );
  }
}
