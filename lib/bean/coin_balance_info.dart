class CoinBalanceInfo {
  String? balance;
  String? type;
  int? loadState;
  List<RecentTransactions>? recentTransactions;
  String? walletAddress;

  CoinBalanceInfo(
      {this.balance,
      this.type,
      this.loadState,
      this.recentTransactions,
      this.walletAddress});

  CoinBalanceInfo.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    type = json['type'];
    loadState = json['loadState'];
    if (json['recentTransactions'] != null) {
      recentTransactions = <RecentTransactions>[];
      json['recentTransactions'].forEach((v) {
        recentTransactions!.add(RecentTransactions.fromJson(v));
      });
    }
    walletAddress = json['walletAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['type'] = type;
    data['loadState'] = loadState;
    if (recentTransactions != null) {
      data['recentTransactions'] =
          recentTransactions!.map((v) => v.toJson()).toList();
    }
    data['walletAddress'] = walletAddress;
    return data;
  }
}

class NetworkItem {
  String name;
  String fee;
  String? gasLimit;
  String? gasPrice;
  NetworkItem(this.name, this.fee, {this.gasLimit, this.gasPrice});
}

class RecentTransactions {
  Amount? amount;
  Date? date;
  String? destinationAddress;
  String? hash;
  String? sourceAddress;
  String? status;

  RecentTransactions(
      {this.amount,
      this.date,
      this.destinationAddress,
      this.hash,
      this.sourceAddress,
      this.status});

  RecentTransactions.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    destinationAddress = json['destinationAddress'];
    hash = json['hash'];
    sourceAddress = json['sourceAddress'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (amount != null) {
      data['amount'] = amount!.toJson();
    }
    if (date != null) {
      data['date'] = date!.toJson();
    }
    data['destinationAddress'] = destinationAddress;
    data['hash'] = hash;
    data['sourceAddress'] = sourceAddress;
    data['status'] = status;
    return data;
  }
}

class Amount {
  String? currencySymbol;
  int? decimals;
  num? perKb;
  num? value;

  Amount({this.currencySymbol, this.decimals, this.perKb, this.value});

  Amount.fromJson(Map<String, dynamic> json) {
    currencySymbol = json['currencySymbol'];
    decimals = json['decimals'];
    perKb = json['perKb'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencySymbol'] = currencySymbol;
    data['decimals'] = decimals;
    data['perKb'] = perKb;
    data['value'] = value;
    return data;
  }
}

class Date {
  int? year;
  int? month;
  int? dayOfMonth;
  int? hourOfDay;
  int? minute;
  int? second;

  Date(
      {this.year,
      this.month,
      this.dayOfMonth,
      this.hourOfDay,
      this.minute,
      this.second});

  Date.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    dayOfMonth = json['dayOfMonth'];
    hourOfDay = json['hourOfDay'];
    minute = json['minute'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['dayOfMonth'] = dayOfMonth;
    data['hourOfDay'] = hourOfDay;
    data['minute'] = minute;
    data['second'] = second;
    return data;
  }
}

class SumBalanceNewInfo {
  late String address;
  late String code;
  String? network;
  String? balance;
  String? id;
  String? uid;
  String? displayUnit;
  String? price;
  String? usd;
  String? usdDisplayAmount;

  SumBalanceNewInfo(
      {required this.address,
      required this.code,
      this.balance,
      this.price,
      this.usd,
      this.id,
      this.displayUnit,
      this.usdDisplayAmount});

  SumBalanceNewInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    code = json['code'];
    balance = json['balance'];
    price = json['price'];
    usd = json['usd'];
    id = json['id'];
    uid = json['uid'];
    displayUnit = json['displayUnit'];
    usdDisplayAmount = json['usdDisplayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['code'] = code;
    data['balance'] = balance;
    data['price'] = price;
    data['usd'] = usd;
    data['id'] = id;
    data['uid'] = uid;
    data['displayUnit'] = displayUnit;

    return data;
  }
}
