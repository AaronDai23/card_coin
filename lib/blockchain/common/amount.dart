// import 'package:decimal/decimal.dart';
//
// import 'amount_type.dart';
// import 'blockchain.dart';
// import 'token.dart';
//
// class Amount {
//   late String currencySymbol;
//   Decimal? value;
//   late int decimals;
//   late AmountType type;
//
//   Amount(
//       {required this.currencySymbol,
//       this.value,
//       required this.decimals,
//       this.type = const AmountType.coin()});
//
//   factory Amount.fromToken({required Token token, Decimal? value}) {
//     return Amount(
//         currencySymbol: token.symbol,
//         decimals: token.decimals,
//         type: AmountType.token(token: token),
//         value: value);
//   }
//
//   factory Amount.fromAmount({required Amount amount, required Decimal value}) {
//     return Amount(
//         currencySymbol: amount.currencySymbol,
//         decimals: amount.decimals,
//         type: amount.type,
//         value: value);
//   }
//
//   factory Amount.fromJson(Map<String,dynamic> json) {
//     AmountType type;
//     String currencySymbol = json['currencySymbol'];
//     if(json['type'] == 'coin'){
//       type = AmountType.coin();
//     }else{
//       type = AmountType.token(token: Token.symbol(symbol: currencySymbol, contractAddress: '', decimals: 0));
//     }
//     return Amount(
//         currencySymbol: currencySymbol,
//         decimals: json['decimals'],
//         type:  type,
//         value: Decimal.parse(json['value']));
//   }
//
//   factory Amount.fromBlockchain(
//       {required Blockchain blockchain,
//         Decimal? value,
//       AmountType type = const AmountType.coin()}) {
//     return Amount(
//         currencySymbol: blockchain.currency,
//         decimals: blockchain.decimals,
//         type: type,
//         value: value??Decimal.zero);
//   }
//
//
// }
//
//
