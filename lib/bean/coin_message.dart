
class CurrencyCoin {
  late String id;
  late String icon;
  late String name;
  late String symbol;
  late List<TokenNetwork> tokenNetworks;

  CurrencyCoin(
      {required this.id,
      required this.icon,
      required this.name,
      required this.symbol,
      required this.tokenNetworks});

  CurrencyCoin copyWith(List<TokenNetwork> tokenNetWorks) {
    return CurrencyCoin(
        id: id,
        icon: icon,
        name: name,
        symbol: symbol,
        tokenNetworks: tokenNetWorks);
  }
}

class CoinMessage {
  late String id;
  late String name;
  late String symbol;
  late String imageUrl;
  late bool active;
  late List<TokenNetwork> networks;

  CoinMessage(
      {required this.id,
      required this.name,
      required this.symbol,
      this.imageUrl = '',
      this.active = true,
      required this.networks});

  CoinMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    imageUrl = json['imageUrl'] ?? '';
    active = json['active'] ?? true;
    if (json['networks'] != null) {
      networks = <TokenNetwork>[];
      json['networks'].forEach((v) {
        networks.add(TokenNetwork.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    data['imageUrl'] = imageUrl;
    data['active'] = active;
    data['networks'] = networks.map((v) => v.toJson()).toList();
    return data;
  }
}

class TokenNetwork {
  late String networkId;
  late String imageUrl;
  String? networkName;
  String? contractAddress;
  int? decimalCount;
  bool testnet = false;

  TokenNetwork(
      {required this.networkId,
      this.imageUrl = '',
      this.networkName,
      this.contractAddress,
      this.decimalCount,
      this.testnet = false});

  TokenNetwork.fromJson(Map<String, dynamic> json) {
    networkId = json['networkId'];
    imageUrl = json['imageUrl'] ?? '';
    networkName = json['networkName'];
    contractAddress = json['contractAddress'];
    decimalCount = json['decimalCount'];
    testnet = json['testnet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['networkId'] = networkId;
    data['imageUrl'] = imageUrl;
    data['networkName'] = networkName;
    data['contractAddress'] = contractAddress;
    data['decimalCount'] = decimalCount;
    data['testnet'] = testnet;
    return data;
  }
}
