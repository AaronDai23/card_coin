class ValidateMethod {
  String? code;
  String? createBy;
  int? createTime;
  String? id;
  String? imageUrl;
  String? name;
  String? orgId;
  int? seq;
  String? status;
  String? updateBy;
  String? value;

  ValidateMethod(
      {this.code,
        this.createBy,
        this.createTime,
        this.id,
        this.imageUrl,
        this.name,
        this.orgId,
        this.seq,
        this.status,
        this.updateBy,
        this.value});

  ValidateMethod.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    orgId = json['orgId'];
    seq = json['seq'];
    status = json['status'];
    updateBy = json['updateBy'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['orgId'] = orgId;
    data['seq'] = seq;
    data['status'] = status;
    data['updateBy'] = updateBy;
    data['value'] = value;
    return data;
  }
}
