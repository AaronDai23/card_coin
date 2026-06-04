import 'dart:convert';
import 'dart:typed_data';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/utils/hex_utils.dart';

class CurrencyInfoResponse {
  int? code;
  String? errorMessage;
  CurrencyInfo currencyInfo;

  CurrencyInfoResponse(this.currencyInfo, {this.code, this.errorMessage});
}

class CurrencyInfo {
  late CurrencyData currencyData;
  String? balance;
  late String imageUrl;
  String? networkName;
  String? address;
  Uint8List? publicKey;
  Uint8List? chainCode;
  List<String>? networkList;
  List<CurrencyInfo>? networkLists;
  String? failCount;
  bool? isHide;
  bool? isTest;

  String get type =>
      currencyData.contractAddress == null ? 'Blockchain' : 'Token';

  CurrencyInfo(
      {this.balance = '0',
      required this.imageUrl,
      required this.currencyData,
      this.address,
      this.networkName,
      this.networkList,
      this.networkLists,
      this.publicKey,
      this.chainCode,
      this.failCount = '0',
      this.isTest = false,
      this.isHide = false});

  get id => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currencyData'] = currencyData.toJson();
    data['balance'] = balance;
    data['address'] = address;
    data['imageUrl'] = imageUrl;
    data['networkName'] = networkName;
    data['publicKey'] = publicKey;
    data['chainCode'] = chainCode;
    data['failCount'] = failCount;
    data['isHide'] = isHide;
    data['isTest'] = isTest;
    print("CurrencyInfo-toJson-isTest:$isTest");
    if (networkLists != null) {
      data['networkLists'] = networkLists!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  CurrencyInfo.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    imageUrl = json['imageUrl'] ?? '';
    networkName = json['networkName'];
    address = json['address'];
    publicKey = json['publicKey'];
    chainCode = json['chainCode'];
    failCount = json['failCount'];
    if (json['isHide'] != null) {
      isHide = json['isHide'];
    }
    if (json['isTest'] != null) {
      isTest = json['isTest'];
      print("CurrencyInfo-fromJson-isTest:$isTest");
    }
    currencyData = CurrencyData.fromJson(json['currencyData']);
    if (json['networkLists'] != null) {
      networkLists = <CurrencyInfo>[];
      json['networkLists'].forEach((v) {
        networkLists!.add(CurrencyInfo.fromJson(v));
      });
    }
  }

  CurrencyInfo.fromCurrencyMessage(CurrencyInfoMessage currencyMessage) {
    balance = currencyMessage.amount?.toString();
    address = currencyMessage.address;
    imageUrl = currencyMessage.networkIcon;
    networkName = currencyMessage.networkName;
    isTest = currencyMessage.isTest == 1 ? true : false;
    currencyData = CurrencyData(currencyMessage.id, currencyMessage.icon,
        currencyMessage.name, currencyMessage.symbol, currencyMessage.networkId,
        decimals: currencyMessage.decimalCount,
        contractAddress: currencyMessage.contractAddress,
        publicKey: currencyMessage.publicKey != null
            ? HexUtils.uint8ListToHex(currencyMessage.publicKey!)
            : "",
        chainCode: currencyMessage.chainCode != null
            ? HexUtils.uint8ListToHex(currencyMessage.chainCode!)
            : "");
  }

  CurrencyInfo.fromCurrencyMessageInBTC(
      CurrencyInfoMessage currencyMessage, bool hide) {
    balance = currencyMessage.amount?.toString();
    address = currencyMessage.address;
    imageUrl = currencyMessage.networkIcon;
    networkName = currencyMessage.networkName;
    isHide = hide;
    isTest = currencyMessage.isTest == 1 ? true : false;
    currencyData = CurrencyData(currencyMessage.id, currencyMessage.icon,
        currencyMessage.name, currencyMessage.symbol, currencyMessage.networkId,
        decimals: currencyMessage.decimalCount,
        contractAddress: currencyMessage.contractAddress,
        publicKey: currencyMessage.publicKey != null
            ? HexUtils.uint8ListToHex(currencyMessage.publicKey!)
            : "",
        chainCode: currencyMessage.chainCode != null
            ? HexUtils.uint8ListToHex(currencyMessage.chainCode!)
            : "");
  }

  CurrencyInfo.fromCurrencyWallet(Map<String, dynamic> json) {
    imageUrl = json['crypto']['imageUrl'];
    currencyData = CurrencyData.fromJson1(json);
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  CurrencyInfo copyWith({
    String? balance,
    String? address,
    String? imageUrl,
    String? failCount,
    List<String>? networkList,
    List<CurrencyInfo>? networkLists,
    Uint8List? publicKey,
    Uint8List? chainCode,
    bool? isHide,
    bool? isTest,
  }) {
    return CurrencyInfo(
      balance: balance ?? this.balance,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      networkName: networkName,
      failCount: failCount ?? this.failCount,
      currencyData: currencyData,
      networkList: networkList ?? this.networkList,
      networkLists: networkLists ?? this.networkLists,
      publicKey: publicKey ?? this.publicKey,
      chainCode: chainCode ?? this.chainCode,
      isHide: isHide ?? this.isHide,
      isTest: isTest ?? this.isTest,
    );
  }
}

class CurrencyData {
  late String id;
  late String icon;
  late String name;
  late String symbol;
  late String networkId;
  int? decimals;
  String? contractAddress;
  String? address;
  String? balance;
  String? publicKey;
  String? chainCode;

  CurrencyData(this.id, this.icon, this.name, this.symbol, this.networkId,
      {this.decimals,
      this.contractAddress,
      this.address,
      this.balance,
      this.publicKey,
      this.chainCode});

  CurrencyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['imageUrl'] ?? '';
    symbol = json['symbol'];
    networkId = json['networkId'];
    decimals = json['decimals'] ?? 0;
    contractAddress = json['contractAddress'] ?? "";
    address = json['address'];
    balance = json['balance'];
    publicKey = json['publicKey'];
    chainCode = json['chainCode'];
  }

  CurrencyData.fromJson1(Map<String, dynamic> json) {
    id = json['code'];
    name = json['name'];
    icon = json['network']['imageUrl'] ?? '';
    networkId = json['chainId'];
    contractAddress = json['network']['contractAddress'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['imageUrl'] = icon;
    data['symbol'] = symbol;
    data['networkId'] = networkId;
    data['decimals'] = decimals;
    data['contractAddress'] = contractAddress;
    data['address'] = address;
    data['balance'] = balance;
    data['publicKey'] = publicKey;
    data['chainCode'] = chainCode;
    return data;
  }

  CurrencyData copy() {
    return CurrencyData(id, name, icon, symbol, networkId,
        decimals: decimals,
        contractAddress: contractAddress,
        address: address,
        balance: balance,
        publicKey: publicKey,
        chainCode: chainCode);
  }

  // 判断币种是否一致的方法
  bool isEqual(CurrencyData data) {
    if (contractAddress != null &&
        data.contractAddress != null &&
        (contractAddress!.isNotEmpty) &&
        (data.contractAddress!.isNotEmpty)) {
      return contractAddress == data.contractAddress;
    }
    return false;
  }

  String getRealySymbol() {
    if (contractAddress != null) {
      return symbol;
    } else {
      return "";
    }
  }
}

class CurrencyDetail {
  String? balance;
  String? type;
  int? loadState;
  String? walletAddress;

  CurrencyDetail({this.balance, this.type, this.loadState, this.walletAddress});

  CurrencyDetail.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    type = json['type'];
    loadState = json['loadState'];
    walletAddress = json['walletAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['type'] = type;
    data['loadState'] = loadState;
    data['walletAddress'] = walletAddress;
    return data;
  }
}

class BlockchainDetail {
  bool? success;
  String? balance;
  List<HistoryTransaction>? recentTransactions;
  String? walletAddress;

  BlockchainDetail(
      {this.success,
      this.balance,
      this.recentTransactions,
      this.walletAddress});

  BlockchainDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    balance = json['balance'];
    if (json['recentTransactions'] != null) {
      recentTransactions = <HistoryTransaction>[];
      json['recentTransactions'].forEach((v) {
        recentTransactions!.add(HistoryTransaction.fromJson(v));
      });
    }
    walletAddress = json['walletAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['balance'] = balance;
    if (recentTransactions != null) {
      data['recentTransactions'] =
          recentTransactions!.map((v) => v.toJson()).toList();
    }
    data['walletAddress'] = walletAddress;
    return data;
  }
}

class HistoryTransaction {
  Amount? amount;
  Date? date;
  String? destinationAddress;
  String? hash;
  String? sourceAddress;
  String? status;

  HistoryTransaction(
      {this.amount,
      this.date,
      this.destinationAddress,
      this.hash,
      this.sourceAddress,
      this.status});

  HistoryTransaction.fromJson(Map<String, dynamic> json) {
    amount =
        json['amount'] != null ? Amount.fromJson(json['amount']) : null;
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
  double? perKb;
  double? value;

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
