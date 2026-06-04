class CoinInfo {
  String? address;
  String? balance;
  String? chainId;
  String? id;
  String? code;
  String? displayName;
  List<CoinInfo>? networks;

  CoinInfo(
      {this.address,
      this.balance,
      this.chainId,
      this.id,
      this.code,
      this.displayName});

  CoinInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = json['balance'];
    chainId = json['chainId'];
    id = json['id'];
    code = json['code'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'balance': balance,
      'chainId': chainId,
      'id': id,
      'code': code,
      'displayName': displayName
    };
  }
}

class Wallect {
  late String chainId;
  late String code;
  late String name;

  Wallect({
    required this.code,
    required this.chainId,
    required this.name,
  });

  Wallect.fromJson(Map<String, dynamic> json) {
    chainId = json['chainId'];
    print('chainId:$chainId');
    code = json['code'];
    print('code:$code');
    name = json['name'];
    print('name:$name');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['chainId'] = chainId;
    data['name'] = name;
    return data;
  }
}
