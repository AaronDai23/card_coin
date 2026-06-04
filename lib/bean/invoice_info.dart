class InvoiceInfo {
  late String amountUnit;
  late String amountValue;
  late String invoiceUrl;
  late String memo;
  late String status;
  late String usdDisplayAmount;
  late String usd;

  InvoiceInfo(
      {required this.amountUnit,
      required this.amountValue,
      required this.invoiceUrl,
      required this.memo,
      required this.status,
      required this.usd});

  InvoiceInfo.fromJson(Map<String, dynamic> json) {
    amountUnit = json['amountUnit'];
    amountValue = json['amountValue'];
    invoiceUrl = json['invoiceUrl'];
    memo = json['memo'];
    status = json['status'];
    usd = json['usd'];
    usdDisplayAmount = json['usdDisplayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountUnit'] = amountUnit;
    data['amountValue'] = amountValue;
    data['invoiceUrl'] = invoiceUrl;
    data['memo'] = memo;
    data['status'] = status;
    data['usd'] = usd;
    data['usdDisplayAmount'] = usdDisplayAmount;
    return data;
  }
}
