class PageCategoryItem {
  String? targetName;
  String? code;
  String? typeName;
  int? updateTime;
  String? hoverImageUrl;
  String? type;
  String? categoryName;
  String? orgId;
  String? target;
  bool? token;
  String? createBy;
  int? createTime;
  String? updateBy;
  String? imageUrl;
  String? name;
  String? href;
  String? id;
  bool? wordPressToken;
  String? category;
  int? seq;
  String? status;
  bool? hiddenTab;

  PageCategoryItem(
      {this.targetName,
      this.code,
      this.typeName,
      this.updateTime,
      this.hoverImageUrl,
      this.type,
      this.categoryName,
      this.orgId,
      this.target,
      this.token,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.imageUrl,
      this.name,
      this.href,
      this.id,
      this.wordPressToken,
      this.category,
      this.seq,
      this.status,
      this.hiddenTab});

  PageCategoryItem.fromJson(Map<String, dynamic> json) {
    targetName = json['targetName'];
    code = json['code'];
    typeName = json['typeName'];
    updateTime = json['updateTime'];
    hoverImageUrl = json['hoverImageUrl'];
    type = json['type'];
    categoryName = json['categoryName'];
    orgId = json['orgId'];
    target = json['target'];
    token = json['token'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    updateBy = json['updateBy'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    href = json['href'];
    id = json['id'];
    wordPressToken = json['wordPressToken'];
    category = json['category'];
    seq = json['seq'];
    status = json['status'];
    hiddenTab = json['hiddenTab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['targetName'] = targetName;
    data['code'] = code;
    data['typeName'] = typeName;
    data['updateTime'] = updateTime;
    data['hoverImageUrl'] = hoverImageUrl;
    data['type'] = type;
    data['categoryName'] = categoryName;
    data['orgId'] = orgId;
    data['target'] = target;
    data['token'] = token;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['updateBy'] = updateBy;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['href'] = href;
    data['id'] = id;
    data['wordPressToken'] = wordPressToken;
    data['category'] = category;
    data['seq'] = seq;
    data['status'] = status;
    data['hiddenTab'] = hiddenTab;
    return data;
  }
}
