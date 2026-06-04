class StartPageInfo {
  String? actionTarget;
  String? actionType;
  String? activity;
  String? callback;
  bool? completed;
  String? description;
  String? name;
  String? operation;
  bool? token;

  StartPageInfo(
      {this.actionTarget,
        this.actionType,
        this.activity,
        this.callback,
        this.completed,
        this.description,
        this.name,
        this.operation,
        this.token});

  StartPageInfo.fromJson(Map<String, dynamic> json) {
    actionTarget = json['actionTarget'];
    actionType = json['actionType'];
    activity = json['activity'];
    callback = json['callback'];
    completed = json['completed'];
    description = json['description'];
    name = json['name'];
    operation = json['operation'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionTarget'] = actionTarget;
    data['actionType'] = actionType;
    data['activity'] = activity;
    data['callback'] = callback;
    data['completed'] = completed;
    data['description'] = description;
    data['name'] = name;
    data['operation'] = operation;
    data['token'] = token;
    return data;
  }
}

