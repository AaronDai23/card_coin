class UpdateInfo {
  int? code;
  String? appName;
  String? appTypeName;
  String? filePath;
  String? description;
  String? source;
  String? versionName;
  String? version;
  String? orgId;
  int? versionCode;
  String? fileFullPath;
  String? buttonsMD5;
  String? path;
  String? createBy;
  int? createTime;
  bool? forceUpgrade;
  String? updateBy;
  String? appType;
  String? name;
  String? statusName;
  String? id;
  String? packageName;
  String? status;

  UpdateInfo(
      {this.code,
        this.appName,
        this.appTypeName,
        this.filePath,
        this.description,
        this.source,
        this.versionName,
        this.version,
        this.orgId,
        this.versionCode,
        this.fileFullPath,
        this.buttonsMD5,
        this.path,
        this.createBy,
        this.createTime,
        this.forceUpgrade,
        this.updateBy,
        this.appType,
        this.name,
        this.statusName,
        this.id,
        this.packageName,
        this.status});

  UpdateInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    appName = json['appName'];
    appTypeName = json['appTypeName'];
    filePath = json['filePath'];
    description = json['description'];
    source = json['source'];
    versionName = json['versionName'];
    version = json['version'];
    orgId = json['orgId'];
    versionCode = json['versionCode'];
    fileFullPath = json['fileFullPath'];
    buttonsMD5 = json['buttonsMD5'];
    path = json['path'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    forceUpgrade = json['forceUpgrade'];
    updateBy = json['updateBy'];
    appType = json['appType'];
    name = json['name'];
    statusName = json['statusName'];
    id = json['id'];
    packageName = json['packageName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['appName'] = appName;
    data['appTypeName'] = appTypeName;
    data['filePath'] = filePath;
    data['description'] = description;
    data['source'] = source;
    data['versionName'] = versionName;
    data['version'] = version;
    data['orgId'] = orgId;
    data['versionCode'] = versionCode;
    data['fileFullPath'] = fileFullPath;
    data['buttonsMD5'] = buttonsMD5;
    data['path'] = path;
    data['createBy'] = createBy;
    data['createTime'] = createTime;
    data['forceUpgrade'] = forceUpgrade;
    data['updateBy'] = updateBy;
    data['appType'] = appType;
    data['name'] = name;
    data['statusName'] = statusName;
    data['id'] = id;
    data['packageName'] = packageName;
    data['status'] = status;
    return data;
  }
}



