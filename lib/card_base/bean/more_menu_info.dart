class MoreMenuInfo {
  String? code;
  String? typeName;
  String? description;
  String? type;
  String? orgId;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? imageUrl;
  String? name;
  String? id;
  List<MoreMenuItem>? items;
  int? seq;
  String? status;

  MoreMenuInfo(
      {this.code,
      this.typeName,
      this.description,
      this.type,
      this.orgId,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.imageUrl,
      this.name,
      this.id,
      this.items,
      this.seq,
      this.status});

  MoreMenuInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    typeName = json['typeName'];
    description = json['description'];
    type = json['type'];
    orgId = json['orgId'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    id = json['id'];
    if (json['items'] != null) {
      items = <MoreMenuItem>[];
      json['items'].forEach((v) {
        items!.add(MoreMenuItem.fromJson(v));
      });
    }
    seq = json['seq'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['typeName'] = typeName;
    data['description'] = description;
    data['type'] = type;
    data['orgId'] = orgId;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['id'] = id;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['seq'] = seq;
    data['status'] = status;
    return data;
  }
}

class MoreMenuItem {
  String? fileName;
  String? targetName;
  String? bannerId;
  String? typeName;
  String? description;
  String? remark;
  String? type;
  String? orgId;
  String? target;
  bool? token;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? name;
  String? fileUrl;
  String? href;
  String? id;
  bool? wordPressToken;
  int? seq;
  String? status;

  MoreMenuItem(
      {this.fileName,
      this.targetName,
      this.bannerId,
      this.typeName,
      this.description,
      this.remark,
      this.type,
      this.orgId,
      this.target,
      this.token,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.name,
      this.fileUrl,
      this.href,
      this.id,
      this.wordPressToken,
      this.seq,
      this.status});

  MoreMenuItem.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    targetName = json['targetName'];
    bannerId = json['bannerId'];
    typeName = json['typeName'];
    description = json['description'];
    remark = json['remark'];
    type = json['type'];
    orgId = json['orgId'];
    target = json['target'];
    token = json['token'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    name = json['name'];
    fileUrl = json['fileUrl'];
    href = json['href'];
    id = json['id'];
    wordPressToken = json['wordPressToken'];
    seq = json['seq'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileName'] = fileName;
    data['targetName'] = targetName;
    data['bannerId'] = bannerId;
    data['typeName'] = typeName;
    data['description'] = description;
    data['remark'] = remark;
    data['type'] = type;
    data['orgId'] = orgId;
    data['target'] = target;
    data['token'] = token;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['name'] = name;
    data['fileUrl'] = fileUrl;
    data['href'] = href;
    data['id'] = id;
    data['wordPressToken'] = wordPressToken;
    data['seq'] = seq;
    data['status'] = status;
    return data;
  }
}
