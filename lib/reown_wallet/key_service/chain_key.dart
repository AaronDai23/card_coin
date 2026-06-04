import 'dart:convert';

class ChainKey {
  final String blockchainId;
  final List<String> chains;
  final String privateKey;
  final String publicKey;
  final String address;

  ChainKey({
    required this.blockchainId,
    required this.chains,
    required this.privateKey,
    required this.publicKey,
    required this.address,
  });

  String get namespace {
    if (chains.isNotEmpty) {
      return chains.first.split(':').first;
    }
    return '';
  }

  Map<String, dynamic> toJson() => {
        'blockchainId': blockchainId,
        'chains': chains,
        'privateKey': privateKey,
        'publicKey': publicKey,
        'address': address,
      };

  factory ChainKey.fromJson(Map<String, dynamic> json) {
    return ChainKey(
      chains: (json['chains'] as List).map((e) => '$e').toList(),
      blockchainId: json['blockchainId'],
      privateKey: json['privateKey'],
      publicKey: json['publicKey'],
      address: json['address'],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
