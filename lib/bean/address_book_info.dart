class AddressBookInfo {
  const AddressBookInfo({
    required this.name,
    required this.address,
    required this.remark,
  });

  final String name;
  final String address;
  final String remark;

  AddressBookInfo copy({String? name, String? address, String? remark}) {
    return AddressBookInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      remark: remark ?? this.remark,
    );
  }

  factory AddressBookInfo.fromJson(Map<String, dynamic> json) {
    return AddressBookInfo(
      name: json['name'],
      address: json['address'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['remark'] = remark;
    return data;
  }
}
