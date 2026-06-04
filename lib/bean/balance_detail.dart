class FlashBalance {
  late String amountUnit;
  late String amountValue;
  late String primaryBalance;
  late String primaryUnit;
  late String usd;
  late String price;
  late String priceUnit;
  late String? usdDisplayAmount;

  FlashBalance({required this.amountUnit, required this.amountValue});

  FlashBalance.fromJson(Map<String, dynamic> json) {
    amountUnit = json['amountUnit'];
    amountValue = json['amountValue'];
    primaryBalance = json['primaryBalance'];
    primaryUnit = json['primaryUnit'];
    usd = json['usd'];
    price = json['price'];
    priceUnit = json['priceUnit'] ?? '';
    usdDisplayAmount = json['usdDisplayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountUnit'] = amountUnit;
    data['amountValue'] = amountValue;
    data['primaryBalance'] = primaryBalance;
    data['primaryUnit'] = primaryUnit;
    data['usd'] = usd;
    data['price'] = price;
    data['priceUnit'] = priceUnit;
    data['usdDisplayAmount'] = usdDisplayAmount;
    return data;
  }
}

class SumBalanceInfo {
  late String address;
  late String code;
  String? network;
  late double balance;
  String? id;
  String? displayUnit;
  BalanceDetail? cryptoBalance;
  FlashBalance? lightningBalance;
  late double price;
  late double usd;

  SumBalanceInfo(
      {required this.address,
      required this.code,
      required this.balance,
      required this.price,
      required this.usd,
      this.id,
      this.displayUnit,
      this.cryptoBalance,
      this.lightningBalance});

  SumBalanceInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    code = json['code'];
    balance = double.parse(json['balance'].toString());
    price = double.parse(json['price'].toString());
    usd = double.parse(json['usd'].toString());
    id = json['id'];
    displayUnit = json['displayUnit'];
    cryptoBalance = json['cryptoBalance'] != null
        ? BalanceDetail.fromJson(json['cryptoBalance'])
        : null;
    lightningBalance = json['lightningBalance'] != null
        ? FlashBalance.fromJson(json['lightningBalance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['code'] = code;
    data['balance'] = balance;
    data['price'] = price;
    data['usd'] = usd;
    data['id'] = id;
    data['displayUnit'] = displayUnit;
    if (cryptoBalance != null) {
      data['chip'] = cryptoBalance!.toJson();
    }
    if (lightningBalance != null) {
      data['chip'] = lightningBalance!.toJson();
    }

    return data;
  }
}

class BalanceDetail {
  late String address;
  late String code;
  late double balance;
  late double price;
  late String imageUrl;
  late double usd;
  late String explorer;
  late String name;

  BalanceDetail(
      {required this.address,
      required this.code,
      required this.balance,
      required this.price,
      required this.imageUrl,
      required this.usd,
      required this.explorer,
      required this.name});

  BalanceDetail.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    code = json['code'];
    balance = double.parse(json['balance'].toString());
    price = json['price'];
    imageUrl = json['imageUrl'];
    usd = double.parse(json['usd'].toString());
    explorer = json['explorer'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['code'] = code;
    data['balance'] = balance;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['usd'] = usd;
    data['explorer'] = explorer;
    data['name'] = name;
    return data;
  }
}
