class CoinMessageItem {
  final String id;
  final String sender;
  final String message;
  final int createTime;
  final bool isRead;

  CoinMessageItem({
    required this.id,
    required this.sender,
    required this.message,
    required this.createTime,
    this.isRead = false,
  });

  factory CoinMessageItem.fromJson(Map<String, dynamic> json) {
    return CoinMessageItem(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
      createTime: json['createTime'],
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'createTime': createTime,
      'isRead': isRead,
    };
  }
}
