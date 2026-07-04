import 'package:card_coin/bean/coin_balance_info.dart';
import 'package:card_coin/bean/fiat_bean.dart';
import 'package:card_coin/bean/page_field_config_info.dart';
import 'package:card_coin/bean/sales_data.dart';
import 'package:card_coin/card_base/bean/Investment_select_info.dart';
import 'package:card_coin/card_base/bean/dapp_info.dart';
import 'package:card_coin/card_base/bean/debouncer.dart';
import 'package:card_coin/card_base/widgets/slide_toact_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../../../bean/card_info_bean.dart';
import '../../../../../../widget/base_page_loading.dart';

class MyCardState extends LoadPageState<MyCardState> {
  SmartCardDetail? cardDetail;

  List<SalesData> lineDatas = [];
  FiatInfo currentFiat = FiatInfo(
      symbol: 'USDT',
      imageUrl: '',
      name: "USDT",
      currentPrice: "1.00",
      scale: '2',
      currency: '\$');
  String cryptoTotalPrice = '0.00';
  String KlineTitle = "KLine Data";
  String KlineCode = "";
  SumBalanceNewInfo? sumBalanceInfo;
  int lastClickedTime = 0;
  Debouncer debouncer = Debouncer();
  String? domainUrl;
  SuperTooltipController controller1 = SuperTooltipController();
  SuperTooltipController controller2 = SuperTooltipController();
  SuperTooltipController controller3 = SuperTooltipController();
  InvestmentSelectInfo? investmentSelectInfo;
  bool isExpanded = true; // 控制展开/折叠
  List<FlSpot> spotList = [];
  double maxY = 0.0; // 控制展开/折叠
  double avargX = 0.0; //
  bool isBTC = false;
  double maxY1 = 0.0; // 控制展开/折叠
  double minY = 0.0; // 控制展开/折叠
  Map<String, String> map = {};
  bool isSliButtonComplete = false;
  double dragPosition = 0.0;
  bool isSwitched = true;
  String? customerSmartCardId;
  double oCur = 0.0; //
  double newCur = 0.0; //
  List valueArr = [0.0, 0.0];
  FlSpot? maxSpot;
  double? touchedX;
  double? touchXPosition;
  FlSpot? lastTouchedSpot;

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
  GlobalKey<SlideToActButtonState> slideKey = GlobalKey();
  List<List<InvestmentSelectInfo>> pickerData = [];
  PageFieldConfigInfo pageConfig = PageFieldConfigInfo();
  List<DappInfo> dapplist = [];
  bool isNeedSyncUid = false;
  int homeSeconds = 60;
  String? taskItemId;
  String? ndefAAR;
  bool hasReportedPrimaryContentVisible = false;

  @override
  MyCardState clone() {
    return MyCardState()
      ..errorMsg = errorMsg
      ..cardDetail = cardDetail
      ..domainUrl = domainUrl
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..lastClickedTime = lastClickedTime
      ..debouncer = debouncer
      ..isExpanded = isExpanded
      ..investmentSelectInfo = investmentSelectInfo
      ..spotList = spotList
      ..map = map
      ..isSwitched = isSwitched
      ..maxY = maxY
      ..avargX = avargX
      ..maxY1 = maxY1
      ..minY = minY
      ..isBTC = isBTC
      ..oCur = oCur
      ..newCur = newCur
      ..valueArr = valueArr
      ..controller1 = controller1
      ..controller2 = controller2
      ..controller3 = controller3
      ..isSliButtonComplete = isSliButtonComplete
      ..dragPosition = dragPosition
      ..slideKey = slideKey
      ..maxSpot = maxSpot
      ..touchedX = touchedX
      ..touchXPosition = touchXPosition
      ..lastTouchedSpot = lastTouchedSpot
      ..customerSmartCardId = customerSmartCardId
      ..intervalExtend1 = intervalExtend1
      ..intervalExtend2 = intervalExtend2
      ..intervalExtend3 = intervalExtend3
      ..intervalExtend1Period = intervalExtend1Period
      ..intervalExtend2Period = intervalExtend2Period
      ..intervalExtend3Period = intervalExtend3Period
      ..selectInfo1 = selectInfo1
      ..selectInfo2 = selectInfo2
      ..selectInfo3 = selectInfo3
      ..pickerData = pickerData
      ..pageConfig = pageConfig
      ..dapplist = dapplist
      ..isNeedSyncUid = isNeedSyncUid
      ..lineDatas = lineDatas
      ..KlineCode = KlineCode
      ..KlineTitle = KlineTitle
      ..currentFiat = currentFiat
      ..cryptoTotalPrice = cryptoTotalPrice
      ..homeSeconds = homeSeconds
      ..sumBalanceInfo = sumBalanceInfo
      ..taskItemId = taskItemId
      ..hasReportedPrimaryContentVisible = hasReportedPrimaryContentVisible
      ..ndefAAR = ndefAAR
      ..loadStatus = loadStatus;
  }
}

MyCardState initState(Map<String, dynamic>? args) {
  String? taskItemId = args?["taskItemId"];
  return MyCardState()
    ..loadStatus = LoadType.loadSuccess
    ..taskItemId = taskItemId
    ..currentFiat = FiatInfo.empty();
}
