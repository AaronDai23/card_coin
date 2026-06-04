class SendInvoiceInfo {
  late num amount;
  late int expireTime;
  late String memo;
  late num price;
  late num primaryBalance;
  late String primaryUnit;
  late String unit;
  late num usd;

  SendInvoiceInfo(
      {required this.amount,
        required this.expireTime,
        required this.memo,
        required this.price,
        required this.primaryBalance,
        required this.primaryUnit,
        required this.unit,
        required this.usd});

  SendInvoiceInfo.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    expireTime = json['expireTime'];
    memo = json['memo'];
    price = json['price'];
    primaryBalance = json['primaryBalance'];
    primaryUnit = json['primaryUnit'];
    unit = json['unit'];
    usd = json['usd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['expireTime'] = expireTime;
    data['memo'] = memo;
    data['price'] = price;
    data['primaryBalance'] = primaryBalance;
    data['primaryUnit'] = primaryUnit;
    data['unit'] = unit;
    data['usd'] = usd;
    return data;
  }
}
