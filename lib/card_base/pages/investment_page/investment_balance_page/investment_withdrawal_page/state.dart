import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/card_base/bean/investment_withdrawal.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/lightning_sign_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/widgets.dart';

class InvestmentWithdrawalState
    implements GlobalBaseState<InvestmentWithdrawalState> {
  InvestmentBalance? detail;
  TextEditingController amountController = TextEditingController();

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = FocusNode();

  List<InvestmentWithdrawal> investmentList = [];
  InvestmentWithdrawal? investment;

  String errorText = "";
  String mount = "";
  late String uid;

  LightningSignInfo? singInfo;

  @override
  InvestmentWithdrawalState clone() {
    return InvestmentWithdrawalState()
      ..errorMsg = errorMsg
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..detail = detail
      ..amountController = amountController
      ..focusNode = focusNode
      ..mount = mount
      ..errorText = errorText
      ..uid = uid
      ..singInfo = singInfo
      ..investmentList = investmentList
      ..investment = investment
      ..loadStatus = loadStatus;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  String errorMsg = '';

  LoadType loadStatus = LoadType.loading;
}

InvestmentWithdrawalState initState(Map<String, dynamic>? args) {
  InvestmentBalance detail = args!['detail'];
  String uid = args['uid'];
  return InvestmentWithdrawalState()
    ..detail = detail
    ..uid = uid;
}
