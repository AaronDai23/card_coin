import 'package:card_coin/bean/investment_config.dart';
import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InvestmentState extends LoadPageState<InvestmentState> {
  late List<InvestmentInfo> list;
  late RefreshController refreshController;
  InvestmentConfig? investmentConfig;
  late String uid = "";
  @override
  InvestmentState clone() {
    return InvestmentState()
      ..list = list
      ..uid = uid
      ..languageLocale = languageLocale
      ..refreshController = refreshController
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..investmentConfig = investmentConfig
      ..errorMsg = errorMsg;
  }
}

InvestmentState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  InvestmentConfig? investmentConfig = args['investmentConfig'];
  return InvestmentState()
    ..refreshController = RefreshController()
    ..uid = uid
    ..investmentConfig = investmentConfig
    ..list = [];
}
