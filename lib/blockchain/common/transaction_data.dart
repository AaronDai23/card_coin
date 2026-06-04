//
// import 'package:decimal/decimal.dart';
// import 'amount.dart';
//
// class TransactionData {
//   late Amount amount;
//   Amount? fee;
//   late String sourceAddress;
//   late String destinationAddress;
//   late TransactionStatus status;
//   String? date;
//   String? hash;
//   String? contractAddress;
//   TransactionExtras? extras;
//
//   TransactionData(
//       {required this.amount,
//       this.fee,
//       required this.sourceAddress,
//       required this.destinationAddress,
//       this.status = TransactionStatus.unconfirmed,
//       this.date,
//       this.extras,
//       this.hash}) {
//     if (amount.type.isToken) {
//       contractAddress = amount.type.asToken.token.contractAddress;
//     }
//   }
//
//   TransactionData.fromJson(Map<String, dynamic> json) {
//     amount = Amount.fromJson(json['amount']);
//
//     // fee = json['fee'].isNotEmpty() ? Amount.fromJson(json['fee']) : null;
//     sourceAddress = json['sourceAddress'];
//     destinationAddress = json['destinationAddress'];
//     contractAddress = json['contractAddress'];
//     status = TransactionStatus.values.firstWhere((element) => element.name == json['status'].toString().toLowerCase());
//     date = json['date'];
//     hash = json['hash'];
//   }
// }
//
// enum TransactionStatus { confirmed, unconfirmed }
//
// enum TransactionError {
//   amountExceedsBalance,
//   amountLowerExistentialDeposit,
//   feeExceedsBalance,
//   totalExceedsBalance,
//   invalidAmountValue,
//   invalidFeeValue,
//   dustAmount,
//   dustChange,
//   tezosSendAll,
// }
//
// enum TransactionDirection { incoming, outgoing }
//
// class BasicTransactionData {
//   late Decimal balanceDif;
//   String? date;
//   late String destination;
//   late String hash;
//   late bool isConfirmed;
//   late String source;
//
//   BasicTransactionData(
//       {required this.balanceDif,
//       this.date,
//       this.destination = 'unknown',
//       required this.hash,
//       required this.isConfirmed,
//       this.source = 'unknown'});
//
//   BasicTransactionData.fromJson(Map<String, dynamic> json) {
//     balanceDif = Decimal.parse(json['balanceDif'].toString());
//     date = json['date'];
//     destination = json['destination'];
//     hash = json['hash'];
//     isConfirmed = json['isConfirmed'];
//     source = json['source'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['balanceDif'] = balanceDif.toDouble();
//     data['date'] = date;
//     data['destination'] = destination;
//     data['hash'] = hash;
//     data['isConfirmed'] = isConfirmed;
//     data['source'] = source;
//     return data;
//   }
// }
//
// class ResponseDate {
//   late int year;
//   late int month;
//   late int dayOfMonth;
//   late int hourOfDay;
//   late int minute;
//   late int second;
//
//   ResponseDate(
//       {required this.year,
//       required this.month,
//       required this.dayOfMonth,
//       required this.hourOfDay,
//       required this.minute,
//       required this.second});
//
//   @override
//   String toString() {
//     return '$year-$month-$dayOfMonth $hourOfDay:$minute:$second';
//   }
//
//   ResponseDate.fromDateTime(DateTime dateTime){
//     year = dateTime.year;
//     month = dateTime.month;
//     dayOfMonth = dateTime.day;
//     hourOfDay = dateTime.hour;
//     minute = dateTime.minute;
//     second = dateTime.second;
//   }
//
//   DateTime toDateTime(){
//     return DateTime(
//         year,
//         month,
//         dayOfMonth,
//         hourOfDay,
//         minute,
//         second);
//   }
//
//   ResponseDate.fromJson(Map<String, dynamic> json) {
//     year = json['year'];
//     month = json['month'];
//     dayOfMonth = json['dayOfMonth'];
//     hourOfDay = json['hourOfDay'];
//     minute = json['minute'];
//     second = json['second'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['year'] = year;
//     data['month'] = month;
//     data['dayOfMonth'] = dayOfMonth;
//     data['hourOfDay'] = hourOfDay;
//     data['minute'] = minute;
//     data['second'] = second;
//     return data;
//   }
// }
//
// abstract class TransactionExtras {}
