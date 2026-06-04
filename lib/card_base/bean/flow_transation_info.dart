class FlowTransationInfo {
  String? amount;
  String? gasPrice;
  String? gasInfo;
  int? nonce;
  String? remark;
  String? rowTransactionHash;
  String? symbol;
  String? toAddress;
  String? transactionType;

  FlowTransationInfo(
      {this.amount,
      this.gasPrice,
      this.nonce,
      this.remark,
      this.rowTransactionHash,
      this.symbol,
      this.toAddress,
      this.transactionType,
      this.gasInfo});

  factory FlowTransationInfo.fromJson(Map<String, dynamic> json) {
    return FlowTransationInfo(
        amount: json['amount'],
        gasPrice: json['gasPrice'],
        nonce: json['nonce'],
        remark: json['remark'],
        rowTransactionHash: json['rowTransactionHash'],
        symbol: json['symbol'],
        toAddress: json['toAddress'],
        gasInfo: json['gasInfo'],
        transactionType: json['transactionType']);
  }
}
