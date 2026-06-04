import 'package:card_coin/card_base/bean/flow_transation_info.dart';
import 'package:card_coin/card_base/bean/sign_message.dart';
import 'package:card_coin/card_base/bean/smart_card_contract_flow_item.dart';

class FlowProgressNewInfo {
  String? contractBalance;
  String? flowId;
  String? flowItemId;
  String? id;
  String? investmentId;
  String? remarks;
  String? signId;
  int? createTime;
  SignMessage? signMessage;
  SmartCardContractFlowItem? smartCardContractFlowItem;
  String? status;
  FlowTransationInfo? transaction;
  int? transactionCount;
  String? transactionHash;
  String? transactionResult;
  String? transactionResultName;
  String? transactionType;
  String? triggerName;
  String? type;
  String? uid;

  FlowProgressNewInfo(
      {this.contractBalance,
      this.flowId,
      this.flowItemId,
      this.id,
      this.investmentId,
      this.remarks,
      this.signId,
      this.signMessage,
      this.smartCardContractFlowItem,
      this.status,
      this.transaction,
      this.transactionCount,
      this.transactionHash,
      this.transactionResult,
      this.transactionType,
      this.triggerName,
      this.type,
      this.transactionResultName,
      this.createTime,
      this.uid});

  factory FlowProgressNewInfo.fromJson(Map<String, dynamic> json) {
    SignMessage? signMessage;
    if (json['signMessage'] != null) {
      signMessage = SignMessage.fromJson(json['signMessage']);
    }
    SmartCardContractFlowItem? smartCardContractFlowItem;
    if (json['smartCardContractFlowItem'] != null) {
      smartCardContractFlowItem =
          SmartCardContractFlowItem.fromJson(json['smartCardContractFlowItem']);
    }
    FlowTransationInfo? transaction;
    if (json['transaction'] != null) {
      transaction = FlowTransationInfo.fromJson(json['transaction']);
    }

    return FlowProgressNewInfo(
        contractBalance: json['contractBalance'],
        flowId: json['flowId'],
        flowItemId: json['flowItemId'],
        id: json['id'],
        investmentId: json['investmentId'],
        remarks: json['remarks'],
        signId: json['signId'],
        signMessage: signMessage,
        smartCardContractFlowItem: smartCardContractFlowItem,
        status: json['status'],
        transaction: transaction,
        transactionCount: json['transactionCount'],
        transactionHash: json['transactionHash'],
        transactionResult: json['transactionResult'],
        transactionType: json['transactionType'],
        triggerName: json['triggerName'],
        type: json['type'],
        transactionResultName: json['transactionResultName'],
        createTime: json['createTime'],
        uid: json['uid']);
  }
}
