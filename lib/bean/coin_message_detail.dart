class CoinMessageDetail {
  late String id;
  late String sender;
  late int createTime;
  late String message;
  late String imageUrl;

  CoinMessageDetail({
    required this.id,
    required this.sender,
    required this.createTime,
    required this.message,
  });

  CoinMessageDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    createTime = json['createTime'];
    message = json['message'];
    imageUrl = json['imageUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['createTime'] = createTime;
    data['message'] = message;
    data['imageUrl'] = imageUrl;

    return data;
  }
}
