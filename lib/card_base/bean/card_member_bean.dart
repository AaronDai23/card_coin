class MemberCardListInfo {
  int? total;
  List<MemberCardItem>? list;

  MemberCardListInfo({this.total, this.list});

  MemberCardListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      list = <MemberCardItem>[];
      json['rows'].forEach((v) {
        list!.add(MemberCardItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (list != null) {
      data['rows'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberCardItem {
  String? teamName;
  String? nickName;
  String? cardNo;
  String? categoryName;
  String? customerName;
  String? orgId;
  int? createTime;
  String? phone;
  String? teamId;
  String? customerId;
  BrandInfo? brandInfo;
  String? id;
  String? category;
  String? brand;

  MemberCardItem(
      {this.teamName,
        this.nickName,
        this.cardNo,
        this.categoryName,
        this.customerName,
        this.orgId,
        this.createTime,
        this.phone,
        this.teamId,
        this.customerId,
        this.brandInfo,
        this.id,
        this.category,
        this.brand});

  MemberCardItem.fromJson(Map<String, dynamic> json) {
    teamName = json['teamName'];
    nickName = json['nickName'];
    cardNo = json['cardNo'];
    categoryName = json['categoryName'];
    customerName = json['customerName'];
    orgId = json['orgId'];
    createTime = json['createTime'];
    phone = json['phone'];
    teamId = json['teamId'];
    customerId = json['customerId'];
    brandInfo = json['brandInfo'] != null
        ? BrandInfo.fromJson(json['brandInfo'])
        : null;
    id = json['id'];
    category = json['category'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teamName'] = teamName;
    data['nickName'] = nickName;
    data['cardNo'] = cardNo;
    data['categoryName'] = categoryName;
    data['customerName'] = customerName;
    data['orgId'] = orgId;
    data['createTime'] = createTime;
    data['phone'] = phone;
    data['teamId'] = teamId;
    data['customerId'] = customerId;
    if (brandInfo != null) {
      data['brandInfo'] = brandInfo!.toJson();
    }
    data['id'] = id;
    data['category'] = category;
    data['brand'] = brand;
    return data;
  }
}

class BrandInfo {
  String? createBy;
  String? code;
  String? logoImage;
  int? createTime;
  String? updateBy;
  String? backgroundImage;
  String? name;
  String? description;
  int? updateTime;
  String? id;
  String? orgId;
  String? status;

  BrandInfo(
      {this.createBy,
        this.code,
        this.logoImage,
        this.createTime,
        this.updateBy,
        this.backgroundImage,
        this.name,
        this.description,
        this.updateTime,
        this.id,
        this.orgId,
        this.status});

  BrandInfo.fromJson(Map<String, dynamic> json) {
    createBy = json['createBy'];
    code = json['code'];
    logoImage = json['logoImage'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    backgroundImage = json['backgroundImage'];
    name = json['name'];
    description = json['description'];
    updateTime = json['updateTime'];
    id = json['id'];
    orgId = json['orgId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createBy'] = createBy;
    data['code'] = code;
    data['logoImage'] = logoImage;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['backgroundImage'] = backgroundImage;
    data['name'] = name;
    data['description'] = description;
    data['updateTime'] = updateTime;
    data['id'] = id;
    data['orgId'] = orgId;
    data['status'] = status;
    return data;
  }
}

class GroupProfileInfo {
  List<GroupLinkDetailItem>? buttons;
  String? cardId;
  Profile? profile;
  int? id;
  String? deviceId;
  String? userCode;
  String? userProfile;

  GroupProfileInfo(
      {this.buttons,
        this.cardId,
        this.profile,
        this.id,
        this.deviceId,
        this.userCode,
        this.userProfile});

  GroupProfileInfo.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <GroupLinkDetailItem>[];
      json['buttons'].forEach((v) {
        buttons!.add(GroupLinkDetailItem.fromJson(v));
      });
    }
    cardId = json['cardId'];
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    id = json['id'];
    deviceId = json['deviceId'];
    userCode = json['userCode'];
    userProfile = json['userProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['cardId'] = cardId;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['id'] = id;
    data['deviceId'] = deviceId;
    data['userCode'] = userCode;
    data['userProfile'] = userProfile;
    return data;
  }
}

class GroupLinkDetailItem {
  String? prefix;
  String? imageUrl;
  String? name;
  String? description;
  bool? disabled;
  String? id;
  String? label;
  String? type;
  String? value;
  String? isCustomUrl;

  GroupLinkDetailItem(
      {this.prefix,
        this.imageUrl,
        this.name,
        this.description,
        this.disabled,
        this.id,
        this.label,
        this.type,
        this.value,
        this.isCustomUrl});

  GroupLinkDetailItem.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    description = json['description'];
    disabled = json['disabled'];
    id = json['id'];
    label = json['label'];
    type = json['type'];
    value = json['value'];
    isCustomUrl = json['isCustomUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['description'] = description;
    data['disabled'] = disabled;
    data['id'] = id;
    data['label'] = label;
    data['type'] = type;
    data['value'] = value;
    data['isCustomUrl'] = isCustomUrl;
    return data;
  }
}

class Profile {
  String? customerAddress;
  String? logoImage;
  String? backgroundImage;
  String? companyName;
  String? department;
  String? title;
  String? customerName;

  Profile(
      {this.customerAddress,
        this.logoImage,
        this.backgroundImage,
        this.companyName,
        this.department,
        this.title,
        this.customerName});

  Profile.fromJson(Map<String, dynamic> json) {
    customerAddress = json['customerAddress'];
    logoImage = json['logoImage'];
    backgroundImage = json['backgroundImage'];
    companyName = json['companyName'];
    department = json['department'];
    title = json['title'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerAddress'] = customerAddress;
    data['logoImage'] = logoImage;
    data['backgroundImage'] = backgroundImage;
    data['companyName'] = companyName;
    data['department'] = department;
    data['title'] = title;
    data['customerName'] = customerName;
    return data;
  }
}






