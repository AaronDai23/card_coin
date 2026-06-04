import 'package:card_coin/bean/coin_info.dart';
import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:card_coin/card_base/bean/investment_forecast.dart';
import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/card_base/bean/investment_interval.dart';
import 'package:card_coin/card_base/pages/investment_page/investment_handle_page/action.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InvestmentHandleState
    implements GlobalBaseState<InvestmentHandleState>, PageLoad {
  InvestmentActionType actionType = InvestmentActionType.add;
  late RefreshController refreshController;
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  InvestmentInterval investment = InvestmentInterval();
  late List<CoinInfo> coinlist = [];
  List<List<InvestmentSelectInfo>> pickerData = [];
  String uid = '';
  String id = '';
  String errorText = "";
  String mount = "";
  int selectedCoin = 0; // 选中的币种
  int selectedCycle = 0; // 选中的定投周期
  String investmentPeriod = "每天 01:00"; // 选中的具体执行时间
  int intervalExtend1 = 0;
  int intervalExtend2 = 0;
  int intervalExtend3 = 0;
  String intervalExtend1Period = ""; // 选中的具体执行时间
  String intervalExtend2Period = ""; // 选中的具体执行时间
  String intervalExtend3Period = ""; // 选中的具体执行时间
  InvestmentSelectInfo? selectInfo1;
  InvestmentSelectInfo? selectInfo2;
  InvestmentSelectInfo? selectInfo3;
  InvestmentSelectInfo? cycleInfo;

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode2 = FocusNode();

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = FocusNode();

  CoinInfo? coinInfo;

  double totalCoin = 0;

  bool isShowForecast = false;

  String investmentName = '';

  InvestmentConfig? investmentConfig;

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;

  InvestmentInfo? investDetail;

  InvestmentForecast? investmentForecast;

  @override
  InvestmentHandleState clone() {
    return InvestmentHandleState()
      ..actionType = actionType
      ..refreshController = refreshController
      ..amountController = amountController
      ..nameController = nameController
      ..investment = investment
      ..coinlist = coinlist
      ..investDetail = investDetail
      ..id = id
      ..uid = uid
      ..intervalExtend1 = intervalExtend1
      ..intervalExtend2 = intervalExtend2
      ..intervalExtend3 = intervalExtend3
      ..intervalExtend1Period = intervalExtend1Period
      ..intervalExtend2Period = intervalExtend1Period
      ..intervalExtend3Period = intervalExtend1Period
      ..selectInfo1 = selectInfo1
      ..selectInfo2 = selectInfo2
      ..selectInfo3 = selectInfo3
      ..pickerData = pickerData
      ..selectedCoin = selectedCoin
      ..selectedCycle = selectedCycle
      ..loadStatus = loadStatus
      ..mount = mount
      ..focusNode2 = focusNode2
      ..focusNode = focusNode
      ..totalCoin = totalCoin
      ..errorText = errorText
      ..investmentName = investmentName
      ..coinInfo = coinInfo
      ..isShowForecast = isShowForecast
      ..investmentForecast = investmentForecast
      ..investmentConfig = investmentConfig
      ..errorMsg = errorMsg;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

InvestmentHandleState initState(Map<String, dynamic>? args) {
  InvestmentActionType actionType = args!['actionType'];
  String uid = '';
  String id = '';
  if (actionType == InvestmentActionType.detail) {
    uid = args['uid'];
    id = args['id'];
  } else {
    uid = args['uid'];
  }
  InvestmentConfig? investmentConfig = args['investmentConfig'];
  print("InvestmentHandleState-initState:$uid");
  return InvestmentHandleState()
    ..refreshController = RefreshController()
    ..actionType = actionType
    ..investmentConfig = investmentConfig
    ..uid = uid
    ..id = id;
}
