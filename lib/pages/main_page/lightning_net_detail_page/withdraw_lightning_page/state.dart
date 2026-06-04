import 'package:card_coin/bean/balance_detail.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';

import '../light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';

class WithdrawLightningState extends LoadPageState<WithdrawLightningState>{
  late FlashBalance flashBalanceDetail;
  late String uid;
  List<UnitInfo>? unitInfoList;
  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = FocusNode();

  ///文本输入框是否可编辑
  bool isEnable = true;
  UnitInfo? selectedUnit;
  UnitInfo? usdtUnit;
  String mount = "";
  String errorTip = "";
  String usdtStr = "";
  String code = '';
  String curValue = '';
  // String selectUnit;
  @override
  WithdrawLightningState clone() {
    return WithdrawLightningState()
      ..flashBalanceDetail = flashBalanceDetail
      ..uid = uid
      ..focusNode = focusNode
      ..usdtUnit = usdtUnit
      ..unitInfoList = unitInfoList
      ..selectedUnit = selectedUnit
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorTip = errorTip
      ..mount = mount
      ..curValue = curValue
      ..errorMsg = errorMsg
    ;
  }
}

WithdrawLightningState initState(Map<String, dynamic>? args) {
  return WithdrawLightningState()
    ..flashBalanceDetail = args!['flashBalanceDetail']
    ..uid = args['uid'];
}
