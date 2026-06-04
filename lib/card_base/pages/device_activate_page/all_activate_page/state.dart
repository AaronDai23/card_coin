import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class AllActivateState extends LoadPageState<AllActivateState> {
  late String uid;
  ActivateSummary? activateSummary;
  @override
  AllActivateState clone() {
    return AllActivateState()
      ..uid = uid
      ..activateSummary = activateSummary
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
    ;
  }
}

AllActivateState initState(Map<String, dynamic>? args) {
  return AllActivateState()..uid = args!['uid'];
}
