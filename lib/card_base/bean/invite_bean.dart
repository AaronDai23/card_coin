class InviteListInfo {
  int? total;
  List<InviteUser>? rows;

  InviteListInfo({this.total, this.rows});

  InviteListInfo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      rows = <InviteUser>[];
      json['rows'].forEach((v) {
        rows!.add(InviteUser.fromJson(v));
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

class InviteUser {
  Level? level;
  String? phone;
  String? registerTime;
  String? id;
  String? customerName;
  String? orgId;

  InviteUser(
      {this.level,
        this.phone,
        this.registerTime,
        this.id,
        this.customerName,
        this.orgId});

  InviteUser.fromJson(Map<String, dynamic> json) {
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    phone = json['phone'];
    registerTime = json['registerTime'];
    id = json['id'];
    customerName = json['customerName'];
    orgId = json['orgId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (level != null) {
      data['level'] = level!.toJson();
    }
    data['phone'] = phone;
    data['registerTime'] = registerTime;
    data['id'] = id;
    data['customerName'] = customerName;
    data['orgId'] = orgId;
    return data;
  }
}

class Level {
  int? expireDay;
  String? imageUrl;
  String? name;

  Level({this.expireDay, this.imageUrl, this.name});

  Level.fromJson(Map<String, dynamic> json) {
    expireDay = json['expireDay'];
    imageUrl = json['imageUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expireDay'] = expireDay;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    return data;
  }
}

