import 'dart:convert';
// import 'dart:ffi';

class FiatInfo {
  late String symbol;
  late String imageUrl;
  late String name;
  late String currentPrice;
  late String scale;
  late String currency;

  FiatInfo(
      {required this.symbol,
      required this.imageUrl,
      required this.name,
      required this.currentPrice,
      required this.scale,
      required this.currency});

  FiatInfo.empty() {
    symbol = 'USDT';
    imageUrl = '';
    name = 'USDT';
    currentPrice = '1.00';
    scale = '2';
    currency = '\$';
  }

  FiatInfo.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    if (json['currentPrice'] is num) {
      currentPrice = json['currentPrice'].toString();
    } else {
      currentPrice = json['currentPrice'];
    }

    if (json['scale'] is int) {
      scale = json['scale'].toString();
    } else {
      scale = json['scale'];
    }
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['currentPrice'] = currentPrice;
    data['scale'] = scale;
    data['currency'] = currency;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
