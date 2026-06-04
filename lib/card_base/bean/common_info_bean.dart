class CommonInfo {
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

  CommonInfo(
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

  CommonInfo.fromJson(Map<String, dynamic> json) {
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
