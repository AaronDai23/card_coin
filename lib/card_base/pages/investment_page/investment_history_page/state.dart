import 'package:card_coin/card_base/bean/investment_history_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InvestmentHistoryState extends LoadPageState<InvestmentHistoryState> {
  late List<InvestmentHistoryInfo> list;
  late RefreshController refreshController;
  late String uid;
  late String jobId;
  @override
  InvestmentHistoryState clone() {
    return InvestmentHistoryState()
      ..list = list
      ..uid = uid
      ..jobId = jobId
      ..languageLocale = languageLocale
      ..refreshController = refreshController
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }
}

InvestmentHistoryState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  String jobId = args['id'];
  return InvestmentHistoryState()
    ..refreshController = RefreshController()
    ..uid = uid
    ..jobId = jobId
    ..list = [];
}
