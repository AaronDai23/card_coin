import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class FlowHistoryState extends LoadPageState<FlowHistoryState> {
  String uid = '';
  List<FlowProgressNewInfo> steps = [];
  @override
  FlowHistoryState clone() {
    return FlowHistoryState()
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..uid = uid
      ..steps = steps
      ..errorMsg = errorMsg;
  }
}

FlowHistoryState initState(Map<String, dynamic>? args) {
  return FlowHistoryState()..uid = args?['uid'] ?? '';
}
