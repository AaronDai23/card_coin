class LightningSignInfo {
  late String signId;
  late String signMessage;

  LightningSignInfo({required this.signId,required this.signMessage});

  LightningSignInfo.fromJson(Map<String, dynamic> json) {
    signId = json['signId'];
    signMessage = json['signMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['signId'] = signId;
    data['signMessage'] = signMessage;
    return data;
  }
}
