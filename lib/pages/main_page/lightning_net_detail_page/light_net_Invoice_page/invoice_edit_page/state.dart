import 'package:card_coin/bean/invoice_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

class InvoiceEditState implements LoadPageState<InvoiceEditState> {
  @override
  InvoiceEditState clone() {
    return InvoiceEditState()
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus
      ..languageLocale = languageLocale
      ..isEnable = isEnable
      ..seletUnit = seletUnit
      ..mount = mount
      ..errorTip = errorTip
      ..usdtStr = usdtStr
      ..code = code
      ..curValue = curValue
      ..invoiceInfo = invoiceInfo
      ..mainUnitInfo = mainUnitInfo
      ..unitInfos = unitInfos
      ..units = units
      ..usdtUnitInfo = usdtUnitInfo
      ..selectUnitInfo = selectUnitInfo
      ..uid = uid
      ..languageResource = languageResource;
  }

  @override
  String errorMsg = '';

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  LoadType loadStatus = LoadType.loading;

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode2 = FocusNode();

  ///文本输入框是否可编辑
  bool isEnable = true;
  String seletUnit = "";
  String mount = "";
  String errorTip = "";
  String usdtStr = "";
  String code = '';
  String curValue = '';

  InvoiceInfo? invoiceInfo;

  UnitInfo? mainUnitInfo;
  List<UnitInfo>? unitInfos;
  List<String> units = [];
  UnitInfo? usdtUnitInfo;
  String uid = "";
  UnitInfo? selectUnitInfo;
}

InvoiceEditState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  return InvoiceEditState()..uid = uid;
}
