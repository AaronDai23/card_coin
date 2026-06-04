class SignMessage {
  String? signId;
  String? signMessage;

  SignMessage({
    this.signId,
    this.signMessage,
  });
  factory SignMessage.fromJson(Map<String, dynamic> json) {
    return SignMessage(
      signId: json['signId'],
      signMessage: json['signMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['signId'] = signId;
    data['signMessage'] = signMessage;
    return data;
  }
}
