class InvestmentWithdrawal {
  String? address;
  String? balance;
  String? chainId;
  String? code;
  String? id;
  String? netName;
  String? netCode;

  InvestmentWithdrawal({
    this.address,
    this.balance,
    this.chainId,
    this.code,
    this.id,
    this.netName,
    this.netCode,
  });
  InvestmentWithdrawal.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = json['balance'];
    id = json['id'];
    code = json['code'];
    chainId = json['chainId'];
    netName = json['network']['name'];
    netCode = json['network']['code'];
  }
}
