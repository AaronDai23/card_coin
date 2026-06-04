class AssetSummaryInfo {
  List<AssetListData>? assetListData;
  List<AssetTypeData>? assetTypeData;
  String? balance;
  String? price;
  String? priceUnit;
  String? symbol;
  String? uid;
  String? usd;
  String? usdDisplayAmount;

  AssetSummaryInfo(
      {this.assetListData,
      this.assetTypeData,
      this.balance,
      this.price,
      this.priceUnit,
      this.symbol,
      this.uid,
      this.usd,
      this.usdDisplayAmount});

  AssetSummaryInfo.fromJson(Map<String, dynamic> json) {
    if (json['assetListData'] != null) {
      assetListData = <AssetListData>[];
      json['assetListData'].forEach((v) {
        assetListData!.add(AssetListData.fromJson(v));
      });
    }
    if (json['assetTypeData'] != null) {
      assetTypeData = <AssetTypeData>[];
      json['assetTypeData'].forEach((v) {
        assetTypeData!.add(AssetTypeData.fromJson(v));
      });
    }
    balance = json['balance'];
    price = json['price'];
    priceUnit = json['priceUnit'];
    symbol = json['symbol'];
    uid = json['uid'];
    usd = json['usd'];
    usdDisplayAmount = json['usdDisplayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assetListData != null) {
      data['assetListData'] = assetListData!.map((v) => v.toJson()).toList();
    }
    if (assetTypeData != null) {
      data['assetTypeData'] = assetTypeData!.map((v) => v.toJson()).toList();
    }
    data['balance'] = balance;
    data['price'] = price;
    data['priceUnit'] = priceUnit;
    data['symbol'] = symbol;
    data['uid'] = uid;
    data['usd'] = usd;
    data['usdDisplayAmount'] = usdDisplayAmount;
    return data;
  }
}

class AssetListData {
  String? assetType;
  String? assetTypeName;
  String? balance;
  String? description;
  String? name;
  String? price;
  String? priceUnit;
  String? symbol;
  String? uid;
  String? usd;
  String? imageUrl;
  String? usdDisplayAmount;

  AssetListData(
      {this.assetType,
      this.assetTypeName,
      this.balance,
      this.description,
      this.name,
      this.price,
      this.priceUnit,
      this.symbol,
      this.uid,
      this.usd,
      this.usdDisplayAmount,
      this.imageUrl});

  AssetListData.fromJson(Map<String, dynamic> json) {
    assetType = json['assetType'];
    assetTypeName = json['assetTypeName'];
    balance = json['balance'];
    description = json['description'];
    name = json['name'];
    price = json['price'];
    priceUnit = json['priceUnit'];
    symbol = json['symbol'];
    uid = json['uid'];
    usd = json['usd'];
    usdDisplayAmount = json['usdDisplayAmount'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assetType'] = assetType;
    data['assetTypeName'] = assetTypeName;
    data['balance'] = balance;
    data['description'] = description;
    data['name'] = name;
    data['price'] = price;
    data['priceUnit'] = priceUnit;
    data['symbol'] = symbol;
    data['uid'] = uid;
    data['usd'] = usd;
    data['usdDisplayAmount'] = usdDisplayAmount;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class AssetTypeData {
  String? assetType;
  String? assetTypeName;
  String? balance;
  String? price;
  String? priceUnit;
  String? symbol;
  String? uid;
  String? usd;
  String? usdDisplayAmount;

  AssetTypeData(
      {this.assetType,
      this.assetTypeName,
      this.balance,
      this.price,
      this.priceUnit,
      this.symbol,
      this.uid,
      this.usd,
      this.usdDisplayAmount});

  AssetTypeData.fromJson(Map<String, dynamic> json) {
    assetType = json['assetType'];
    assetTypeName = json['assetTypeName'];
    balance = json['balance'];
    price = json['price'];
    priceUnit = json['priceUnit'];
    symbol = json['symbol'];
    uid = json['uid'];
    usd = json['usd'];
    usdDisplayAmount = json['usdDisplayAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assetType'] = assetType;
    data['assetTypeName'] = assetTypeName;
    data['balance'] = balance;
    data['price'] = price;
    data['priceUnit'] = priceUnit;
    data['symbol'] = symbol;
    data['uid'] = uid;
    data['usd'] = usd;
    data['usdDisplayAmount'] = usdDisplayAmount;
    return data;
  }
}
