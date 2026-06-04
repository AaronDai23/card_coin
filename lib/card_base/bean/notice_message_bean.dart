class MessageListInfo {
  int? total;
  List<NoticeMessage>? rows;

  MessageListInfo({this.total, this.rows});

  MessageListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = <NoticeMessage>[];
      json['rows'].forEach((v) {
        rows!.add(NoticeMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoticeMessage {
  bool isSelected = false;

  String? actionActivity;
  String? actionsName;
  String? refType;
  String? typeName;
  String? title;
  String? type;
  String? content;
  String? orgId;
  bool? popup;
  bool? deleted;
  int? createTime;
  String? actionButton;
  String? customerId;
  String? id;
  String? refId;
  String? actions;
  String? status;

  NoticeMessage(
      {this.actionActivity,
      this.actionsName,
      this.refType,
      this.typeName,
      this.title,
      this.type,
      this.content,
      this.orgId,
      this.popup,
      this.deleted,
      this.createTime,
      this.actionButton,
      this.customerId,
      this.id,
      this.refId,
      this.actions,
      this.status});

  NoticeMessage.fromJson(Map<String, dynamic> json) {
    actionActivity = json['actionActivity'];
    actionsName = json['actionsName'];
    refType = json['refType'];
    typeName = json['typeName'];
    title = json['title'];
    type = json['type'];
    content = json['content'];
    orgId = json['orgId'];
    popup = json['popup'];
    deleted = json['deleted'];
    createTime = json['createTime'];
    actionButton = json['actionButton'];
    customerId = json['customerId'];
    id = json['id'];
    refId = json['refId'];
    actions = json['actions'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionActivity'] = actionActivity;
    data['actionsName'] = actionsName;
    data['refType'] = refType;
    data['typeName'] = typeName;
    data['title'] = title;
    data['type'] = type;
    data['content'] = content;
    data['orgId'] = orgId;
    data['popup'] = popup;
    data['deleted'] = deleted;
    data['createTime'] = createTime;
    data['actionButton'] = actionButton;
    data['customerId'] = customerId;
    data['id'] = id;
    data['refId'] = refId;
    data['actions'] = actions;
    data['status'] = status;
    return data;
  }
}

class NoticeDetail {
  String? actionButton;
  String? actionType;
  String? actionTypeName;
  String? actions;
  String? actionsName;
  String? content;
  int? createTime;
  String? customerId;
  bool? deleted;
  String? id;
  String? messageReferId;
  String? orgId;
  bool? popup;
  int? readTime;
  String? refId;
  String? refType;
  String? status;
  String? title;
  String? type;
  String? typeName;

  NoticeDetail(
      {this.actionButton,
      this.actionType,
      this.actionTypeName,
      this.actions,
      this.actionsName,
      this.content,
      this.createTime,
      this.customerId,
      this.deleted,
      this.id,
      this.messageReferId,
      this.orgId,
      this.popup,
      this.readTime,
      this.refId,
      this.refType,
      this.status,
      this.title,
      this.type,
      this.typeName});

  NoticeDetail.fromJson(Map<String, dynamic> json) {
    actionButton = json['actionButton'];
    actionType = json['actionType'];
    actionTypeName = json['actionTypeName'];
    actions = json['actions'];
    actionsName = json['actionsName'];
    content = json['content'];
    createTime = json['createTime'];
    customerId = json['customerId'];
    deleted = json['deleted'];
    id = json['id'];
    messageReferId = json['messageReferId'];
    orgId = json['orgId'];
    popup = json['popup'];
    readTime = json['readTime'];
    refId = json['refId'];
    refType = json['refType'];
    status = json['status'];
    title = json['title'];
    type = json['type'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionButton'] = actionButton;
    data['actionType'] = actionType;
    data['actionTypeName'] = actionTypeName;
    data['actions'] = actions;
    data['actionsName'] = actionsName;
    data['content'] = content;
    data['createTime'] = createTime;
    data['customerId'] = customerId;
    data['deleted'] = deleted;
    data['id'] = id;
    data['messageReferId'] = messageReferId;
    data['orgId'] = orgId;
    data['popup'] = popup;
    data['readTime'] = readTime;
    data['refId'] = refId;
    data['refType'] = refType;
    data['status'] = status;
    data['title'] = title;
    data['type'] = type;
    data['typeName'] = typeName;
    return data;
  }
}

class UnReadCountInfo {
  Result? result;
  int? unReadCount;

  UnReadCountInfo({this.result, this.unReadCount});

  UnReadCountInfo.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    unReadCount = json['unReadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['unReadCount'] = unReadCount;
    return data;
  }
}

class Result {
  String? actionsName;
  String? refType;
  String? typeName;
  String? title;
  String? type;
  String? content;
  String? orgId;
  String? actionType;
  bool? popup;
  String? actionTypeName;
  bool? deleted;
  int? createTime;
  String? messageReferId;
  String? actionButton;
  String? customerId;
  String? id;
  String? refId;
  String? actions;
  String? status;

  Result(
      {this.actionsName,
      this.refType,
      this.typeName,
      this.title,
      this.type,
      this.content,
      this.orgId,
      this.actionType,
      this.popup,
      this.actionTypeName,
      this.deleted,
      this.createTime,
      this.messageReferId,
      this.actionButton,
      this.customerId,
      this.id,
      this.refId,
      this.actions,
      this.status});

  Result.fromJson(Map<String, dynamic> json) {
    actionsName = json['actionsName'];
    refType = json['refType'];
    typeName = json['typeName'];
    title = json['title'];
    type = json['type'];
    content = json['content'];
    orgId = json['orgId'];
    actionType = json['actionType'];
    popup = json['popup'];
    actionTypeName = json['actionTypeName'];
    deleted = json['deleted'];
    createTime = json['createTime'];
    messageReferId = json['messageReferId'];
    actionButton = json['actionButton'];
    customerId = json['customerId'];
    id = json['id'];
    refId = json['refId'];
    actions = json['actions'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionsName'] = actionsName;
    data['refType'] = refType;
    data['typeName'] = typeName;
    data['title'] = title;
    data['type'] = type;
    data['content'] = content;
    data['orgId'] = orgId;
    data['actionType'] = actionType;
    data['popup'] = popup;
    data['actionTypeName'] = actionTypeName;
    data['deleted'] = deleted;
    data['createTime'] = createTime;
    data['messageReferId'] = messageReferId;
    data['actionButton'] = actionButton;
    data['customerId'] = customerId;
    data['id'] = id;
    data['refId'] = refId;
    data['actions'] = actions;
    data['status'] = status;
    return data;
  }
}
