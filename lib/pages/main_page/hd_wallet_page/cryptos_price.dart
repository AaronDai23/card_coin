class CryptosPrice {
  late String code;
  late double price;
  late String cryptoId;

  CryptosPrice(
      {required this.code, required this.price, required this.cryptoId});

  CryptosPrice copy({String? code, double? price, String? cryptoId}) {
    return CryptosPrice(
      code: code ?? this.code,
      price: price ?? this.price,
      cryptoId: cryptoId ?? this.cryptoId,
    );
  }

  CryptosPrice.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['price'] is int) {
      price = double.parse(json['price'].toString());
    } else if (json['price'] is String) {
      price = double.parse(json['price']);
    } else {
      price = json['price'];
    }

    cryptoId = json['cryptoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['price'] = price;
    data['cryptoId'] = cryptoId;
    return data;
  }
}
