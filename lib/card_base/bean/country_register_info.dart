class CountryRegisterInfo {
  String? countryCode;
  String? countryFlag;
  String? countryName;
  String? isoCode;
  String? phoneRegx;
  int? seq;

  CountryRegisterInfo(
      {this.countryCode,
        this.countryFlag,
        this.countryName,
        this.isoCode,
        this.phoneRegx,
        this.seq});

  CountryRegisterInfo.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    countryFlag = json['countryFlag'];
    countryName = json['countryName'];
    isoCode = json['isoCode'];
    phoneRegx = json['phoneRegx'];
    seq = json['seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['countryFlag'] = countryFlag;
    data['countryName'] = countryName;
    data['isoCode'] = isoCode;
    data['phoneRegx'] = phoneRegx;
    data['seq'] = seq;
    return data;
  }
}
