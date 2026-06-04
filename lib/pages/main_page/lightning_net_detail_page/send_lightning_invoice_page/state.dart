import 'dart:async';

import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/send_invoice_info.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

class SendLightningInvoiceState implements Cloneable<SendLightningInvoiceState> {

  TextEditingController invoiceController = TextEditingController();
  SendInvoiceInfo? invoiceInfo;
  late FlashBalance flashBalanceDetail;
  Timer? validateTimer;
  late String uid;
  bool isLoading = false;
  @override
  SendLightningInvoiceState clone() {
    return SendLightningInvoiceState()
      ..invoiceController = invoiceController
      ..invoiceInfo = invoiceInfo
      ..isLoading = isLoading
      ..validateTimer = validateTimer
      ..flashBalanceDetail = flashBalanceDetail
      ..uid = uid
    ;
  }
}

SendLightningInvoiceState initState(Map<String, dynamic>? args) {
  return SendLightningInvoiceState()
    ..flashBalanceDetail = args!['flashBalanceDetail']
    ..uid = args['uid']
  ;
}
