class SystemConfig {
  bool? customerPasswordVerify;

  SystemConfig({this.customerPasswordVerify});

  SystemConfig.fromJson(Map<String, dynamic> json) {
    customerPasswordVerify = json['customerPasswordVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerPasswordVerify'] = customerPasswordVerify;
    return data;
  }
}
