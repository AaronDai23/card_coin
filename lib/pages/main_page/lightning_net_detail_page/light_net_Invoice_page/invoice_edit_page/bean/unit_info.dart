class UnitInfo {
  late String conversion;
  late bool primary;
  late String symbol;
  late String name;
  late String description;

  UnitInfo(
      {required this.conversion,
      required this.primary,
      required this.symbol,
      required this.name,
      required this.description});

  UnitInfo.fromJson(Map<String, dynamic> json) {
    conversion = json['conversion'];
    primary = json['primary'];
    symbol = json['symbol'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversion'] = conversion;
    data['primary'] = primary;
    data['symbol'] = symbol;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
