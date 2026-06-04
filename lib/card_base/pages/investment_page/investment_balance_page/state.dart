import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InvestmentBalanceState extends LoadPageState<InvestmentBalanceState> {
  late List<InvestmentBalance> list;
  late RefreshController refreshController;
  late String uid;
  @override
  InvestmentBalanceState clone() {
    return InvestmentBalanceState()
      ..list = list
      ..uid = uid
      ..languageLocale = languageLocale
      ..refreshController = refreshController
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }
}

InvestmentBalanceState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  return InvestmentBalanceState()
    ..refreshController = RefreshController()
    ..uid = uid
    ..list = [];
}
