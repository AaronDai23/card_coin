import 'dart:async';
import 'dart:ui';

import 'package:card_coin/bean/invoice_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class LightNetInvoiceState implements LoadPageState<LightNetInvoiceState> {
  @override
  LightNetInvoiceState clone() {
    return LightNetInvoiceState()
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..languageLocale = languageLocale
      ..invoiceInfo = invoiceInfo
      ..qrImage = qrImage
      ..timer = timer
      ..seconds = seconds
      ..select_mount = select_mount
      ..select_unit = select_unit
      ..select_usdmount = select_usdmount
      ..uid = uid
      ..languageResource = languageResource;
  }

  @override
  String errorMsg = "";

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;

  InvoiceInfo? invoiceInfo;

  QrImage? qrImage;
  Timer? timer;
  int seconds = 60;

  String select_mount = "0";
  String select_unit = "";
  String select_usdmount = "0";
  String uid = "";
}

LightNetInvoiceState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  return LightNetInvoiceState()..uid = uid;
}
