class PageButtonInfo {
  List<ButtonItem>? buttons;
  String? activity;
  String? activityName;

  PageButtonInfo({this.buttons, this.activity, this.activityName});

  PageButtonInfo.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <ButtonItem>[];
      json['buttons'].forEach((v) {
        buttons!.add(ButtonItem.fromJson(v));
      });
    }
    activity = json['activity'];
    activityName = json['activityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['activity'] = activity;
    data['activityName'] = activityName;
    return data;
  }
}

class ButtonItem {
  String? border;
  String? backgroundColor;
  String? displayType;
  String? shape;
  String? imageUrl;
  String? name;
  String? targetType;
  String? position;
  int? seq;
  String? target;
  bool? token;

  ButtonItem(
      {this.border,
        this.backgroundColor,
        this.displayType,
        this.shape,
        this.imageUrl,
        this.name,
        this.targetType,
        this.position,
        this.seq,
        this.target,
        this.token});

  ButtonItem.fromJson(Map<String, dynamic> json) {
    border = json['border'];
    backgroundColor = json['backgroundColor'];
    displayType = json['displayType'];
    shape = json['shape'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    targetType = json['targetType'];
    position = json['position'];
    seq = json['seq'];
    target = json['target'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['border'] = border;
    data['backgroundColor'] = backgroundColor;
    data['displayType'] = displayType;
    data['shape'] = shape;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['targetType'] = targetType;
    data['position'] = position;
    data['seq'] = seq;
    data['target'] = target;
    data['token'] = token;
    return data;
  }
}

