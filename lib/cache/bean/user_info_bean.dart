class UserInfo {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  Customer? customer;

  UserInfo(
      {this.accessToken, this.refreshToken, this.tokenType, this.customer});

  UserInfo.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['token_type'] = tokenType;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  String? account;
  String? authType;
  String? avatar;
  bool? bindNFC;
  bool? canInvite;
  String? cardNo;
  double? currentBalance;
  String? customerCode;
  String? customerName;
  String? email;
  String? goalType;
  String? id;
  bool? idDetected;
  String? idcard;
  String? inviteCode;
  bool? inviteCodeCustom;
  String? isoCode;
  String? lastLoginTime;
  Level? level;
  String? levelId;
  int? loanTimes;
  bool? needSetPassword;
  String? nickName;
  String? orgId;
  String? passport;
  String? passportImagePathKey;
  String? passportImagePathUrl;
  String? phone;
  String? platform;
  String? registerSource;
  String? residentCertificate;
  String? residentCertificateImagePathKey;
  String? residentCertificateImagePathUrl;
  int? skipIdCard;
  int? status;
  bool? syncAddressBook;
  int? unReadCount;

  Customer(
      {this.account,
        this.authType,
        this.avatar,
        this.bindNFC,
        this.canInvite,
        this.cardNo,
        this.currentBalance,
        this.customerCode,
        this.customerName,
        this.email,
        this.goalType,
        this.id,
        this.idDetected,
        this.idcard,
        this.inviteCode,
        this.inviteCodeCustom,
        this.isoCode,
        this.lastLoginTime,
        this.level,
        this.levelId,
        this.loanTimes,
        this.needSetPassword,
        this.nickName,
        this.orgId,
        this.passport,
        this.passportImagePathKey,
        this.passportImagePathUrl,
        this.phone,
        this.platform,
        this.registerSource,
        this.residentCertificate,
        this.residentCertificateImagePathKey,
        this.residentCertificateImagePathUrl,
        this.skipIdCard,
        this.status,
        this.syncAddressBook,
        this.unReadCount});

  Customer.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    authType = json['authType'];
    avatar = json['avatar'];
    bindNFC = json['bindNFC'];
    canInvite = json['canInvite'];
    cardNo = json['cardNo'];
    currentBalance = json['currentBalance'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    email = json['email'];
    goalType = json['goalType'];
    id = json['id'];
    idDetected = json['idDetected'];
    idcard = json['idcard'];
    inviteCode = json['inviteCode'];
    inviteCodeCustom = json['inviteCodeCustom'];
    isoCode = json['isoCode'];
    lastLoginTime = json['lastLoginTime'];
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    levelId = json['levelId'];
    loanTimes = json['loan_times'];
    needSetPassword = json['needSetPassword'];
    nickName = json['nickName'];
    orgId = json['orgId'];
    passport = json['passport'];
    passportImagePathKey = json['passportImagePathKey'];
    passportImagePathUrl = json['passportImagePathUrl'];
    phone = json['phone'];
    platform = json['platform'];
    registerSource = json['registerSource'];
    residentCertificate = json['residentCertificate'];
    residentCertificateImagePathKey = json['residentCertificateImagePathKey'];
    residentCertificateImagePathUrl = json['residentCertificateImagePathUrl'];
    skipIdCard = json['skipIdCard'];
    status = json['status'];
    syncAddressBook = json['syncAddressBook'];
    unReadCount = json['unReadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account'] = account;
    data['authType'] = authType;
    data['avatar'] = avatar;
    data['bindNFC'] = bindNFC;
    data['canInvite'] = canInvite;
    data['cardNo'] = cardNo;
    data['currentBalance'] = currentBalance;
    data['customerCode'] = customerCode;
    data['customerName'] = customerName;
    data['email'] = email;
    data['goalType'] = goalType;
    data['id'] = id;
    data['idDetected'] = idDetected;
    data['idcard'] = idcard;
    data['inviteCode'] = inviteCode;
    data['inviteCodeCustom'] = inviteCodeCustom;
    data['isoCode'] = isoCode;
    data['lastLoginTime'] = lastLoginTime;
    if (level != null) {
      data['level'] = level!.toJson();
    }
    data['levelId'] = levelId;
    data['loan_times'] = loanTimes;
    data['needSetPassword'] = needSetPassword;
    data['nickName'] = nickName;
    data['orgId'] = orgId;
    data['passport'] = passport;
    data['passportImagePathKey'] = passportImagePathKey;
    data['passportImagePathUrl'] = passportImagePathUrl;
    data['phone'] = phone;
    data['platform'] = platform;
    data['registerSource'] = registerSource;
    data['residentCertificate'] = residentCertificate;
    data['residentCertificateImagePathKey'] =
        residentCertificateImagePathKey;
    data['residentCertificateImagePathUrl'] =
        residentCertificateImagePathUrl;
    data['skipIdCard'] = skipIdCard;
    data['status'] = status;
    data['syncAddressBook'] = syncAddressBook;
    data['unReadCount'] = unReadCount;
    return data;
  }
}

class Level {
  int? expireDay;
  String? imageUrl;
  String? name;

  Level({this.expireDay, this.imageUrl, this.name});

  Level.fromJson(Map<String, dynamic> json) {
    expireDay = json['expireDay'];
    imageUrl = json['imageUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expireDay'] = expireDay;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    return data;
  }
}
