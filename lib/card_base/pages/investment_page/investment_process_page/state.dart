import 'dart:async';

import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/card_base/bean/smart_card_contract_flow_item.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class InvestmentProcessState extends LoadPageState<InvestmentProcessState> {
  List<FlowProgressNewInfo> steps = [];
  InvestmentConfig? investmentConfig;
  String uid = "";
  String id = "";
  Timer? timer;
  int commonSeconds = 15;
  String activedErrorMsg = '';
  String activedSignId = '';
  String activedSignMessage = '';
  String activedSignReslut = '';
  String? intervalExtend1;
  String? intervalExtend2;
  String? intervalExtend3;
  String? assetFrom;
  int fromeIndex = 0; // 0:持续激活 1:中断激活
  // 当前进行的步骤
  int progressSetp = -1;
  bool? isPaika = false;
  bool? isSingle = false;
  bool? isFirstLoadFlow = true;
  bool? isShowActiveCard = true;
  bool isShowWarning = false;
  List<CurrencyInfo> defaultCurrencyList = [];

  @override
  String errorMsg = '';

  @override
  LoadType loadStatus = LoadType.loading;
  @override
  InvestmentProcessState clone() {
    return InvestmentProcessState()
      ..uid = uid
      ..steps = steps
      ..timer = timer
      ..investmentConfig = investmentConfig
      ..activedErrorMsg = activedErrorMsg
      ..activedSignId = activedSignId
      ..activedSignMessage = activedSignMessage
      ..activedSignReslut = activedSignReslut
      ..intervalExtend1 = intervalExtend1
      ..intervalExtend2 = intervalExtend2
      ..intervalExtend3 = intervalExtend3
      ..assetFrom = assetFrom
      ..defaultCurrencyList = defaultCurrencyList
      ..isShowActiveCard = isShowActiveCard
      ..fromeIndex = fromeIndex
      ..progressSetp = progressSetp
      ..isFirstLoadFlow = isFirstLoadFlow
      ..isSingle = isSingle
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..id = id
      ..isShowWarning = isShowWarning
      ..commonSeconds = commonSeconds;
  }
}

InvestmentProcessState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  InvestmentConfig? investmentConfig = args['investmentConfig'];

  String? intervalExtend1 = args['intervalExtend1'];
  String? intervalExtend2 = args['intervalExtend2'];
  String? intervalExtend3 = args['intervalExtend3'];
  String? assetFrom = args['intervalExtend3'];
  String id = args['id'] ?? '';
  int formIndex = int.parse(args['formIndex']);
  bool isSingle = args['isSingle'] ?? false;
  var steps = <FlowProgressNewInfo>[];
  var progressSetp = 0;
  if (formIndex == 1) {
    var initFlowInfo = FlowProgressNewInfo();
    var flowItem = SmartCardContractFlowItem();
    flowItem.description = 'Wallet Initialization';
    flowItem.name = 'Initializing';
    initFlowInfo.transactionResult = "CREATED";
    initFlowInfo.transactionType = 'INITIALIZATION';
    initFlowInfo.smartCardContractFlowItem = flowItem;
    steps.add(initFlowInfo);
    progressSetp = 0;
  }

  print(
      'intervalExtend1:$intervalExtend1,intervalExtend2:$intervalExtend2,intervalExtend3:$intervalExtend3');
  return InvestmentProcessState()
    ..uid = uid
    ..investmentConfig = investmentConfig
    ..fromeIndex = formIndex
    ..assetFrom = assetFrom
    ..steps = steps
    ..id = id
    ..progressSetp = progressSetp
    ..isSingle = isSingle;
}
