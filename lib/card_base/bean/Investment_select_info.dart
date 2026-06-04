class InvestmentSelectInfo {
  String displayValue;
  String key;
  int seq;
  String value;

  InvestmentSelectInfo({
    required this.displayValue,
    required this.key,
    required this.seq,
    required this.value,
  });

  factory InvestmentSelectInfo.fromJson(Map<String, dynamic> json) {
    return InvestmentSelectInfo(
      displayValue: json['displayValue'],
      key: json['key'],
      seq: json['seq'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayValue': displayValue,
      'key': key,
      'seq': seq,
      'value': value,
    };
  }
}
