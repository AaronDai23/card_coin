import '../../../../../widget/base_page_loading.dart';
import '../../../../bean/link_bean.dart';

class TabShareState extends LoadPageState<TabShareState> {
  LinkDomainResponse? linkDomain;
  @override
  TabShareState clone() {
    return TabShareState()
      ..loadStatus = loadStatus
      ..linkDomain = linkDomain
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..errorMsg = errorMsg;
  }
}

TabShareState initState(Map<String, dynamic>? args) {
  return TabShareState();
}
