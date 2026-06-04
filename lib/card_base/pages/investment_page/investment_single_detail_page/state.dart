import 'package:card_coin/card_base/bean/investment_single_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class InvestmentSingleDetailState
    extends LoadPageState<InvestmentSingleDetailState> {
  @override
  String errorMsg = '';

  late String uid = "";
  late String id = "";
  InvestmentSingleInfo? investmentSingleInfo;

  @override
  LoadType loadStatus = LoadType.loading;

  @override
  InvestmentSingleDetailState clone() {
    return InvestmentSingleDetailState()
      ..uid = uid
      ..id = id
      ..loadStatus = loadStatus
      ..investmentSingleInfo = investmentSingleInfo
      ..errorMsg = errorMsg;
  }
}

InvestmentSingleDetailState initState(Map<String, dynamic>? args) {
  String uid = args!['uid'];
  String id = args['id'];
  return InvestmentSingleDetailState()
    ..uid = uid
    ..id = id;
}
