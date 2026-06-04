class CustomerLevelInfo {
  String? docName;
  int? flag;
  String? createTime;
  String? updaterId;
  String? docContext;
  String? extra;
  String? creatorId;
  String? docCode;
  String? remark;
  String? updateTime;
  String? id;
  String? orgId;

  CustomerLevelInfo(
      {this.docName,
      this.flag,
      this.createTime,
      this.updaterId,
      this.docContext,
      this.extra,
      this.creatorId,
      this.docCode,
      this.remark,
      this.updateTime,
      this.id,
      this.orgId});

  CustomerLevelInfo.fromJson(Map<String, dynamic> json) {
    docName = json['docName'];
    flag = json['flag'];
    createTime = json['createTime'];
    updaterId = json['updaterId'];
    docContext = json['docContext'];
    extra = json['extra'];
    creatorId = json['creatorId'];
    docCode = json['docCode'];
    remark = json['remark'];
    updateTime = json['updateTime'];
    id = json['id'];
    orgId = json['orgId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docName'] = docName;
    data['flag'] = flag;
    data['createTime'] = createTime;
    data['updaterId'] = updaterId;
    data['docContext'] = docContext;
    data['extra'] = extra;
    data['creatorId'] = creatorId;
    data['docCode'] = docCode;
    data['remark'] = remark;
    data['updateTime'] = updateTime;
    data['id'] = id;
    data['orgId'] = orgId;
    return data;
  }
}

class MemberLevelInfo {
  CurrentLevel? currentLevel;
  List<CustomerLevel>? customerLevels;

  MemberLevelInfo({this.currentLevel, this.customerLevels});

  MemberLevelInfo.fromJson(Map<String, dynamic> json) {
    currentLevel = json['currentLevel'] != null
        ? CurrentLevel.fromJson(json['currentLevel'])
        : null;
    if (json['customerLevels'] != null) {
      customerLevels = <CustomerLevel>[];
      json['customerLevels'].forEach((v) {
        customerLevels!.add(CustomerLevel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentLevel != null) {
      data['currentLevel'] = currentLevel!.toJson();
    }
    if (customerLevels != null) {
      data['customerLevels'] = customerLevels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentLevel {
  List<Privilege>? privileges;
  int? transcendRankRate;
  String? remark;
  String? orgId;
  int? currentRank;
  int? number;
  int? expireDay;
  String? updateBy;
  int? currentRankRate;
  String? imageUrl;
  String? id;
  bool? locked;
  String? brief;
  String? updateTime;
  String? cardImageUrl;
  String? createBy;
  String? createTime;
  String? name;
  int? customerCount;
  String? status;

  CurrentLevel(
      {this.privileges,
      this.transcendRankRate,
      this.remark,
      this.orgId,
      this.currentRank,
      this.number,
      this.expireDay,
      this.updateBy,
      this.currentRankRate,
      this.imageUrl,
      this.id,
      this.locked,
      this.brief,
      this.updateTime,
      this.cardImageUrl,
      this.createBy,
      this.createTime,
      this.name,
      this.customerCount,
      this.status});

  CurrentLevel.fromJson(Map<String, dynamic> json) {
    if (json['privileges'] != null) {
      privileges = <Privilege>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privilege.fromJson(v));
      });
    }
    transcendRankRate = json['transcendRankRate'];
    remark = json['remark'];
    orgId = json['orgId'];
    currentRank = json['currentRank'];
    number = json['number'];
    expireDay = json['expireDay'];
    updateBy = json['updateBy'];
    currentRankRate = json['currentRankRate'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    locked = json['locked'];
    brief = json['brief'];
    updateTime = json['updateTime'];
    cardImageUrl = json['cardImageUrl'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    name = json['name'];
    customerCount = json['customerCount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    data['transcendRankRate'] = transcendRankRate;
    data['remark'] = remark;
    data['orgId'] = orgId;
    data['currentRank'] = currentRank;
    data['number'] = number;
    data['expireDay'] = expireDay;
    data['updateBy'] = updateBy;
    data['currentRankRate'] = currentRankRate;
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    data['locked'] = locked;
    data['brief'] = brief;
    data['updateTime'] = updateTime;
    data['cardImageUrl'] = cardImageUrl;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['name'] = name;
    data['customerCount'] = customerCount;
    data['status'] = status;
    return data;
  }
}

class CustomerLevel {
  List<Privilege>? privileges;
  String? remark;
  String? orgId;
  int? number;
  int? expireDay;
  String? updateBy;
  String? imageUrl;
  String? id;
  bool? locked;
  String? brief;
  String? updateTime;
  String? cardImageUrl;
  String? createBy;
  String? createTime;
  String? name;
  int? customerCount;
  String? status;

  CustomerLevel(
      {this.privileges,
      this.remark,
      this.orgId,
      this.number,
      this.expireDay,
      this.updateBy,
      this.imageUrl,
      this.id,
      this.locked,
      this.brief,
      this.updateTime,
      this.cardImageUrl,
      this.createBy,
      this.createTime,
      this.name,
      this.customerCount,
      this.status});

  CustomerLevel.fromJson(Map<String, dynamic> json) {
    if (json['privileges'] != null) {
      privileges = <Privilege>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privilege.fromJson(v));
      });
    }
    remark = json['remark'];
    orgId = json['orgId'];
    number = json['number'];
    expireDay = json['expireDay'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    locked = json['locked'];
    brief = json['brief'];
    updateTime = json['updateTime'];
    cardImageUrl = json['cardImageUrl'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    name = json['name'];
    customerCount = json['customerCount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    data['remark'] = remark;
    data['orgId'] = orgId;
    data['number'] = number;
    data['expireDay'] = expireDay;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    data['locked'] = locked;
    data['brief'] = brief;
    data['updateTime'] = updateTime;
    data['cardImageUrl'] = cardImageUrl;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['name'] = name;
    data['customerCount'] = customerCount;
    data['status'] = status;
    return data;
  }
}

class Privilege {
  String? imageInactiveUrl;
  bool? display;
  String? description;
  String? remark;
  String? orgId;
  String? createBy;
  String? privilegeId;
  String? updateBy;
  String? imageUrl;
  String? levelId;
  String? name;
  String? id;
  String? category;
  bool? locked;
  String? value;
  String? imageActiveUrl;

  Privilege(
      {this.imageInactiveUrl,
      this.display,
      this.description,
      this.remark,
      this.orgId,
      this.createBy,
      this.privilegeId,
      this.updateBy,
      this.imageUrl,
      this.levelId,
      this.name,
      this.id,
      this.category,
      this.locked,
      this.value,
      this.imageActiveUrl});

  Privilege.fromJson(Map<String, dynamic> json) {
    imageInactiveUrl = json['imageInactiveUrl'];
    display = json['display'];
    description = json['description'];
    remark = json['remark'];
    orgId = json['orgId'];
    createBy = json['createBy'];
    privilegeId = json['privilegeId'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    levelId = json['levelId'];
    name = json['name'];
    id = json['id'];
    category = json['category'];
    locked = json['locked'];
    value = json['value'];
    imageActiveUrl = json['imageActiveUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageInactiveUrl'] = imageInactiveUrl;
    data['display'] = display;
    data['description'] = description;
    data['remark'] = remark;
    data['orgId'] = orgId;
    data['createBy'] = createBy;
    data['privilegeId'] = privilegeId;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['levelId'] = levelId;
    data['name'] = name;
    data['id'] = id;
    data['category'] = category;
    data['locked'] = locked;
    data['value'] = value;
    data['imageActiveUrl'] = imageActiveUrl;
    return data;
  }
}

class LevelRank {
  String? customerName;
  String? customerPhone;
  String? imageUrl;
  String? name;
  String? brief;
  int? rank;
  int? loanTimes;
  num? amount;

  LevelRank(
      {this.customerName,
      this.customerPhone,
      this.imageUrl,
      this.name,
      this.brief,
      this.rank,
      this.loanTimes,
      this.amount});

  LevelRank.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    brief = json['brief'];
    rank = json['rank'];
    loanTimes = json['loanTimes'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerName'] = customerName;
    data['customerPhone'] = customerPhone;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['brief'] = brief;
    data['rank'] = rank;
    data['loanTimes'] = loanTimes;
    data['amount'] = amount;
    return data;
  }
}

class PrivilegeDetail {
  String? imageInactiveUrl;
  bool? display;
  String? description;
  String? remark;
  String? orgId;
  String? privilegeCode;
  String? regx;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? name;
  String? privilegeCodeName;
  String? id;
  String? category;
  String? imageActiveUrl;

  PrivilegeDetail(
      {this.imageInactiveUrl,
      this.display,
      this.description,
      this.remark,
      this.orgId,
      this.privilegeCode,
      this.regx,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.name,
      this.privilegeCodeName,
      this.id,
      this.category,
      this.imageActiveUrl});

  PrivilegeDetail.fromJson(Map<String, dynamic> json) {
    imageInactiveUrl = json['imageInactiveUrl'];
    display = json['display'];
    description = json['description'];
    remark = json['remark'];
    orgId = json['orgId'];
    privilegeCode = json['privilegeCode'];
    regx = json['regx'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    name = json['name'];
    privilegeCodeName = json['privilegeCodeName'];
    id = json['id'];
    category = json['category'];
    imageActiveUrl = json['imageActiveUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageInactiveUrl'] = imageInactiveUrl;
    data['display'] = display;
    data['description'] = description;
    data['remark'] = remark;
    data['orgId'] = orgId;
    data['privilegeCode'] = privilegeCode;
    data['regx'] = regx;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['name'] = name;
    data['privilegeCodeName'] = privilegeCodeName;
    data['id'] = id;
    data['category'] = category;
    data['imageActiveUrl'] = imageActiveUrl;
    return data;
  }
}
