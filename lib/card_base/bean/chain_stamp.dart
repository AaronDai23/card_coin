class ChainStamp {
  String? uid;
  String? alias;
  String? cardNo;

  ChainStamp({required this.uid, required this.alias, required this.cardNo});

  factory ChainStamp.fromJson(Map<String, dynamic> json) {
    return ChainStamp(
      uid: json['uid'] as String,
      alias: json['alias'] as String,
      cardNo: json['cardNo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'alias': alias,
      'cardNo': cardNo,
    };
  }
}
