class BannerResponse {
  String? code;
  String? createBy;
  int? createTime;
  String? description;
  String? id;
  String? imageUrl;
  List<BannerItem>? items;
  String? name;
  String? orgId;
  int? seq;
  String? status;
  String? type;
  String? typeName;
  String? updateBy;
  int? updateTime;

  BannerResponse(
      {this.code,
      this.createBy,
      this.createTime,
      this.description,
      this.id,
      this.imageUrl,
      this.items,
      this.name,
      this.orgId,
      this.seq,
      this.status,
      this.type,
      this.typeName,
      this.updateBy,
      this.updateTime});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    description = json['description'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    if (json['items'] != null) {
      items = <BannerItem>[];
      json['items'].forEach((v) {
        items!.add(BannerItem.fromJson(v));
      });
    }
    name = json['name'];
    orgId = json['orgId'];
    seq = json['seq'];
    status = json['status'];
    type = json['type'];
    typeName = json['typeName'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['description'] = description;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['orgId'] = orgId;
    data['seq'] = seq;
    data['status'] = status;
    data['type'] = type;
    data['typeName'] = typeName;
    data['updateBy'] = updateBy;
    data['updateTime'] = updateTime;
    return data;
  }
}

class BannerItem {
  String? bannerId;
  String? content;
  String? createBy;
  int? createTime;
  String? description;
  String? fileName;
  String? fileUrl;
  String? href;
  String? id;
  String? name;
  String? orgId;
  String? remark;
  int? seq;
  String? status;
  String? target;
  String? targetName;
  bool? token;
  String? type;
  String? typeName;
  String? updateBy;
  int? updateTime;
  bool? wordPressToken;

  BannerItem(
      {this.bannerId,
      this.content,
      this.createBy,
      this.createTime,
      this.description,
      this.fileName,
      this.fileUrl,
      this.href,
      this.id,
      this.name,
      this.orgId,
      this.remark,
      this.seq,
      this.status,
      this.target,
      this.targetName,
      this.token,
      this.type,
      this.typeName,
      this.updateBy,
      this.updateTime,
      this.wordPressToken});

  BannerItem.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'];
    content = json['content'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    description = json['description'];
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    href = json['href'];
    id = json['id'];
    name = json['name'];
    orgId = json['orgId'];
    remark = json['remark'];
    seq = json['seq'];
    status = json['status'];
    target = json['target'];
    targetName = json['targetName'];
    token = json['token'];
    type = json['type'];
    typeName = json['typeName'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
    wordPressToken = json['wordPressToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bannerId'] = bannerId;
    data['content'] = content;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['description'] = description;
    data['fileName'] = fileName;
    data['fileUrl'] = fileUrl;
    data['href'] = href;
    data['id'] = id;
    data['name'] = name;
    data['orgId'] = orgId;
    data['remark'] = remark;
    data['seq'] = seq;
    data['status'] = status;
    data['target'] = target;
    data['targetName'] = targetName;
    data['token'] = token;
    data['type'] = type;
    data['typeName'] = typeName;
    data['updateBy'] = updateBy;
    data['updateTime'] = updateTime;
    data['wordPressToken'] = wordPressToken;

    return data;
  }
}
