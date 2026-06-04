class LoginMethod {
  String? createBy;
  String? code;
  int? createTime;
  String? updateBy;
  String? name;
  String? id;
  String? value;
  String? orgId;
  int? seq;
  String? imageUrl;
  String? status;

  LoginMethod(
      {this.createBy,
      this.code,
      this.createTime,
      this.updateBy,
      this.name,
      this.id,
      this.value,
      this.orgId,
      this.seq,
      this.status,
      this.imageUrl});

  LoginMethod.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    code = json['code'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    name = json['name'];
    id = json['id'];
    value = json['value'];
    orgId = json['orgId'];
    seq = json['seq'];
    status = json['status'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createBy'] = createBy;
    data['code'] = code;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['name'] = name;
    data['id'] = id;
    data['value'] = value;
    data['orgId'] = orgId;
    data['seq'] = seq;
    data['status'] = status;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

enum RegisterType { email, phone, nfc }

extension RegisterTypeExt on RegisterType {
  String get page {
    if (this == RegisterType.email) {
      return 'emailRegisterPage';
    } else if (this == RegisterType.phone) {
      return 'phoneRegisterPage';
    } else {
      return 'nfcRegisterPage';
    }
  }

  String get text {
    if (this == RegisterType.email) {
      return '邮箱注册';
    } else if (this == RegisterType.phone) {
      return '手机号注册';
    } else {
      return 'NFC卡注册';
    }
  }
}

class CountryInfo {
  String? regStatus;
  String? rechargeStatus;
  int? scale;
  String? remark;
  String? orgId;
  String? exchangeRateTypeName;
  String? countryFlag;
  String? updateBy;
  String? countryCode;
  String? exchangeStatus;
  String? customerId;
  String? currency;
  String? id;
  int? seq;
  String? currencySymbol;
  String? exchangeRateType;
  String? createBy;
  String? isoCode;
  String? cashOutStatus;
  String? currencyFlag;
  String? countryName;
  String? status;

  CountryInfo(
      {this.regStatus,
      this.rechargeStatus,
      this.scale,
      this.remark,
      this.orgId,
      this.exchangeRateTypeName,
      this.countryFlag,
      this.updateBy,
      this.countryCode,
      this.exchangeStatus,
      this.customerId,
      this.currency,
      this.id,
      this.seq,
      this.currencySymbol,
      this.exchangeRateType,
      this.createBy,
      this.isoCode,
      this.cashOutStatus,
      this.currencyFlag,
      this.countryName,
      this.status});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    regStatus = json['regStatus'];
    rechargeStatus = json['rechargeStatus'];
    scale = json['scale'];
    remark = json['remark'];
    orgId = json['orgId'];
    exchangeRateTypeName = json['exchangeRateTypeName'];
    countryFlag = json['countryFlag'];
    updateBy = json['updateBy'];
    countryCode = json['countryCode'];
    exchangeStatus = json['exchangeStatus'];
    customerId = json['customerId'];
    currency = json['currency'];
    id = json['id'];
    seq = json['seq'];
    currencySymbol = json['currencySymbol'];
    exchangeRateType = json['exchangeRateType'];
    createBy = json['createBy'];
    isoCode = json['isoCode'];
    cashOutStatus = json['cashOutStatus'];
    currencyFlag = json['currencyFlag'];
    countryName = json['countryName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regStatus'] = regStatus;
    data['rechargeStatus'] = rechargeStatus;
    data['scale'] = scale;
    data['remark'] = remark;
    data['orgId'] = orgId;
    data['exchangeRateTypeName'] = exchangeRateTypeName;
    data['countryFlag'] = countryFlag;
    data['updateBy'] = updateBy;
    data['countryCode'] = countryCode;
    data['exchangeStatus'] = exchangeStatus;
    data['customerId'] = customerId;
    data['currency'] = currency;
    data['id'] = id;
    data['seq'] = seq;
    data['currencySymbol'] = currencySymbol;
    data['exchangeRateType'] = exchangeRateType;
    data['createBy'] = createBy;
    data['isoCode'] = isoCode;
    data['cashOutStatus'] = cashOutStatus;
    data['currencyFlag'] = currencyFlag;
    data['countryName'] = countryName;
    data['status'] = status;
    return data;
  }
}
