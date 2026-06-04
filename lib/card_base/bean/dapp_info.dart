class DappInfo {
  bool? anonymous;
  String? brief;
  String? createBy;
  int? createTime;
  String? href;
  String? id;
  String? imageUrl;
  String? name;
  String? orgId;
  bool? recommend;
  int? seq;
  String? status;
  String? updateBy;
  int? updateTime;

  DappInfo(
      {this.anonymous,
      this.brief,
      this.createBy,
      this.createTime,
      this.href,
      this.id,
      this.imageUrl,
      this.name,
      this.orgId,
      this.recommend,
      this.seq,
      this.status,
      this.updateBy,
      this.updateTime});

  DappInfo.fromJson(Map<String, dynamic> json) {
    anonymous = json['anonymous'];
    brief = json['brief'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    href = json['href'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    orgId = json['orgId'];
    recommend = json['recommend'];
    seq = json['seq'];
    status = json['status'];
    updateBy = json['updateBy'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['anonymous'] = anonymous;
    data['brief'] = brief;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['href'] = href;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['orgId'] = orgId;
    data['recommend'] = recommend;
    data['seq'] = seq;
    data['status'] = status;
    data['updateBy'] = updateBy;
    data['updateTime'] = updateTime;
    return data;
  }
}
