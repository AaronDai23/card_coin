import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class SingleActivateState extends LoadPageState<SingleActivateState> {
  late String uid;
  ActivateSummary? activateSummary;
  @override
  SingleActivateState clone() {
    return SingleActivateState()
      ..uid = uid
      ..activateSummary = activateSummary
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }
}

SingleActivateState initState(Map<String, dynamic>? args) {
  return SingleActivateState()..uid = args!['uid'];
}
