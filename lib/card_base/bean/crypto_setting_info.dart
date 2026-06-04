class CryptoSettingInfo {
  bool? active;
  bool? asset;
  String? code;
  String? id;
  String? imageUrl;
  String? name;
  List<Network>? networks;
  String? symbol;

  CryptoSettingInfo(
      {this.active,
        this.asset,
        this.code,
        this.id,
        this.imageUrl,
        this.name,
        this.networks,
        this.symbol});

  CryptoSettingInfo.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    asset = json['asset'];
    code = json['code'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    if (json['networks'] != null) {
      networks = <Network>[];
      json['networks'].forEach((v) {
        networks!.add(Network.fromJson(v));
      });
    }
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['asset'] = asset;
    data['code'] = code;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    if (networks != null) {
      data['networks'] = networks!.map((v) => v.toJson()).toList();
    }
    data['symbol'] = symbol;
    return data;
  }
}

class Network {
  bool? display;
  String? networkName;
  String? imageUrl;
  String? networkId;

  Network({this.display, this.imageUrl, this.networkId});

  Network.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    networkName = json['networkName'];
    imageUrl = json['imageUrl'];
    networkId = json['networkId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    data['networkName'] = networkName;
    data['imageUrl'] = imageUrl;
    data['networkId'] = networkId;
    return data;
  }
}
