class VerifyMethod {
  String? brief;
  String? method;

  VerifyMethod({this.brief, this.method});

  VerifyMethod.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brief'] = brief;
    data['method'] = method;
    return data;
  }
}

