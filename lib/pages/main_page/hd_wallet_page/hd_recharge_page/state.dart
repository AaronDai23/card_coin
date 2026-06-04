import 'dart:ui';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HdRechargeState implements GlobalBaseState<HdRechargeState>, PageLoad {
  late CurrencyInfo currencyInfo; // 网络下代币/或者公链币
  late CurrencyInfo bigCurrency; //币种
  late QrImage qrImage;
  late QrCode qrCode;
  int index = -1;

  @override
  HdRechargeState clone() {
    return HdRechargeState()
      ..currencyInfo = currencyInfo
      ..languageLocale = languageLocale
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..index = index
      ..qrImage = qrImage
      ..qrCode = qrCode
      ..bigCurrency = bigCurrency
      ..languageResource = languageResource;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loadSuccess;
}

HdRechargeState initState(Map<String, dynamic>? args) {
  CurrencyInfo bigCurrency = args!['currencyInfo'];
  var list = bigCurrency.networkLists?.toList() ?? [];
  list.retainWhere((element) => element.address?.isNotEmpty ?? false);
  bigCurrency = bigCurrency.copyWith(networkLists: list);
  final currencyInfo = bigCurrency.networkLists!.first;
  QrCode qrCode = QrCode.fromData(
    data: currencyInfo.address!,
    errorCorrectLevel: QrErrorCorrectLevel.H,
  );

  QrImage qrImage = QrImage(qrCode);

  return HdRechargeState()
    ..currencyInfo = currencyInfo
    ..index = 0
    ..bigCurrency = bigCurrency
    ..qrImage = qrImage
    ..qrCode = qrCode;
}
