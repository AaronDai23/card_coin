import 'package:card_coin/bean/coin_message_item.dart';

class CoinMessageSummary {
  late int total;
  late List<CoinMessageItem> items;

  CoinMessageSummary({
    required this.total,
    required this.items,
  });

  factory CoinMessageSummary.fromJson(Map<String, dynamic> json) {
    return CoinMessageSummary(
      total: json['total'] ?? 0,
      items: (json['rows'] as List?)
              ?.map((e) => CoinMessageItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'rows': items.map((e) => e.toJson()).toList(),
    };
  }
}
