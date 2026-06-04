class CountryInfo {
  late String countryCode;
  late String countryName;
  late String currencySymbol;
  late String isoCode;

  CountryInfo(
      {required this.countryCode, required this.countryName, required this.currencySymbol, required this.isoCode});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    currencySymbol = json['currencySymbol'];
    isoCode = json['isoCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['countryName'] = countryName;
    data['currencySymbol'] = currencySymbol;
    data['isoCode'] = isoCode;
    return data;
  }
}