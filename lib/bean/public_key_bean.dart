class PublicKeyBean {
  final bool enable;
  final String publicKey;
  final String symbol;

  const PublicKeyBean({
    required this.enable,
    required this.publicKey,
    required this.symbol,
  });

  factory PublicKeyBean.fromJson(Map<String, dynamic> json) {
    // enable 字段可能是 bool、String("true")、int(1)，兼容多种类型
    final enableRaw = json['enable'];
    final enable = enableRaw == true ||
        enableRaw == 1 ||
        enableRaw?.toString().toLowerCase() == 'true';
    return PublicKeyBean(
      enable: enable,
      publicKey: json['publicKey']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
    );
  }
}
