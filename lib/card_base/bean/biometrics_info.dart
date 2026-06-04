class BiometricsInfo {
  String? biometricsName;
  String? biometricsType;
  String? deviceId;
  String? customerId;
  String? imageUrl;
  bool? enable;

  BiometricsInfo(
      {this.biometricsName,
      this.biometricsType,
      this.deviceId,
      this.customerId,
      this.imageUrl,
      this.enable});

  BiometricsInfo.fromJson(Map<String, dynamic> json) {
    biometricsName = json['biometricsName'];
    biometricsType = json['biometricsType'];
    deviceId = json['deviceId'];
    customerId = json['customerId'];
    imageUrl = json['imageUrl'];
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['biometricsName'] = biometricsName;
    data['biometricsType'] = biometricsType;
    data['deviceId'] = deviceId;
    data['customerId'] = customerId;
    data['imageUrl'] = imageUrl;
    data['enable'] = enable;
    return data;
  }
}
