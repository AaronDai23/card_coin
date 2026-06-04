class DetailResponse {
  List<LinkDetailItem>? buttons;
  String? postName;
  String? description;
  String? header;
  String? postTitle;
  String? avatar;
  int? id;

  DetailResponse(
      {this.buttons,
        this.postName,
        this.description,
        this.header,
        this.postTitle,
        this.avatar,
        this.id});

  DetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <LinkDetailItem>[];
      json['buttons'].forEach((v) {
        buttons!.add(LinkDetailItem.fromJson(v));
      });
    }
    postName = json['postName'];
    description = json['description'];
    header = json['header'];
    postTitle = json['postTitle'];
    avatar = json['avatar'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['postName'] = postName;
    data['description'] = description;
    data['header'] = header;
    data['postTitle'] = postTitle;
    data['avatar'] = avatar;
    data['id'] = id;
    return data;
  }
}

class LinkDetailItem {
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

  LinkDetailItem(
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

  LinkDetailItem.fromJson(Map<String, dynamic> json) {
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



class LinkTypeItem {
  String? prefix;
  int? count;
  String? description;
  int? updateTime;
  String? type;
  String? regx;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? imageUrl;
  String? name;
  String? id;
  int? seq;
  String? status;

  LinkTypeItem(
      {this.prefix,
        this.count,
        this.description,
        this.updateTime,
        this.type,
        this.regx,
        this.createBy,
        this.createTime,
        this.updateBy,
        this.imageUrl,
        this.name,
        this.id,
        this.seq,
        this.status});

  LinkTypeItem.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    count = json['count'];
    description = json['description'];
    updateTime = json['updateTime'];
    type = json['type'];
    regx = json['regx'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    id = json['id'];
    seq = json['seq'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['count'] = count;
    data['description'] = description;
    data['updateTime'] = updateTime;
    data['type'] = type;
    data['regx'] = regx;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['id'] = id;
    data['seq'] = seq;
    data['status'] = status;
    return data;
  }
}



class LinkDomainResponse {
  String? domain;
  String? qrCode;

  LinkDomainResponse({this.domain, this.qrCode});

  LinkDomainResponse.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    qrCode = json['qrCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['domain'] = domain;
    data['qrCode'] = qrCode;
    return data;
  }
}


class LinkTypeDetail {
  String? prefix;
  int? count;
  String? description;
  String? type;
  String? regx;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? imageUrl;
  String? name;
  String? id;
  int? seq;
  String? status;

  LinkTypeDetail(
      {this.prefix,
        this.count,
        this.description,
        this.type,
        this.regx,
        this.createBy,
        this.createTime,
        this.updateBy,
        this.imageUrl,
        this.name,
        this.id,
        this.seq,
        this.status});

  LinkTypeDetail.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    count = json['count'];
    description = json['description'];
    type = json['type'];
    regx = json['regx'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    id = json['id'];
    seq = json['seq'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['count'] = count;
    data['description'] = description;
    data['type'] = type;
    data['regx'] = regx;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['id'] = id;
    data['seq'] = seq;
    data['status'] = status;
    return data;
  }
}

class LinkProfileInfo {
  List<LinkDetailItem>? buttons;
  String? cardId;
  Profile? profile;
  int? id;
  String? deviceId;
  String? userCode;
  String? userProfile;

  LinkProfileInfo(
      {
        this.buttons,
        this.cardId,
        this.profile,
        this.id,
        this.deviceId,
        this.userCode,
        this.userProfile});

  LinkProfileInfo.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <LinkDetailItem>[];
      json['buttons'].forEach((v) {
        buttons!.add(LinkDetailItem.fromJson(v));
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


class Profile {
  String? customerAddress;
  String? logoImage;
  String? backgroundImage;
  String? companyName;
  String? department;
  String? title;
  String? customerName;
  String? qrImage;
  String? cardId;
  Profile(
      {this.customerAddress,
        this.logoImage,
        this.backgroundImage,
        this.companyName,
        this.department,
        this.title,
        this.customerName,
        this.qrImage,
        this.cardId
      });

  Profile.fromJson(Map<String, dynamic> json) {
    customerAddress = json['customerAddress'];
    logoImage = json['logoImage'];
    backgroundImage = json['backgroundImage'];
    companyName = json['companyName'];
    department = json['department'];
    title = json['title'];
    customerName = json['customerName'];
    qrImage = json['qrImage'];
    cardId = json['cardId'];
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
    data['qrImage'] = qrImage;
    data['cardId'] = cardId;
    return data;
  }
}


class CardListInfo {
  int? total;
  List<NFCCardItem>? list;

  CardListInfo({this.total, this.list});

  CardListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      list = <NFCCardItem>[];
      json['rows'].forEach((v) {
        list!.add(NFCCardItem.fromJson(v));
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

class NFCCardItem {
  String? deviceType;
  String? cardNo;
  num? amount;
  String? categoryName;
  String? deviceId;
  String? deviceName;
  String? orgId;
  String? createBy;
  bool? major;
  int? createTime;
  String? updateBy;
  String? customerId;
  BrandInfo? brandInfo;
  String? id;
  String? category;
  String? brand;
  String? status;

  Profile? postCardProfile;


  NFCCardItem(
      {this.deviceType,
        this.cardNo,
        this.amount,
        this.categoryName,
        this.deviceId,
        this.deviceName,
        this.orgId,
        this.createBy,
        this.major,
        this.createTime,
        this.updateBy,
        this.customerId,
        this.brandInfo,
        this.id,
        this.category,
        this.brand,
        this.status});

  NFCCardItem.fromJson(Map<String, dynamic> json) {
    deviceType = json['deviceType'];
    cardNo = json['cardNo'];
    amount = json['amount'];
    categoryName = json['categoryName'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    orgId = json['orgId'];
    createBy = json['createBy'];
    major = json['major'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    customerId = json['customerId'];
    brandInfo = json['brandInfo'] != null
        ? BrandInfo.fromJson(json['brandInfo'])
        : null;
    id = json['id'];
    category = json['category'];
    brand = json['brand'];
    status = json['status'];
    postCardProfile =
    json['postCardProfile'] != null ? Profile.fromJson(json['postCardProfile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceType'] = deviceType;
    data['cardNo'] = cardNo;
    data['amount'] = amount;
    data['categoryName'] = categoryName;
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    data['orgId'] = orgId;
    data['createBy'] = createBy;
    data['major'] = major;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['customerId'] = customerId;
    if (brandInfo != null) {
      data['brandInfo'] = brandInfo!.toJson();
    }
    data['id'] = id;
    data['category'] = category;
    data['brand'] = brand;
    data['status'] = status;
    if (postCardProfile != null) {
      data['postCardProfile'] = postCardProfile!.toJson();
    }
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
    data['id'] = id;
    data['orgId'] = orgId;
    data['status'] = status;
    return data;
  }
}







