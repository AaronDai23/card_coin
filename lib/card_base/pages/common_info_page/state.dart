

import '../../../widget/base_page_loading.dart';

class CommonInfoState extends LoadPageState<CommonInfoState> {

  late String docUrl;
  String? docTitle;
  String? docContent;

  @override
  CommonInfoState clone() {
    return CommonInfoState()
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..docTitle = docTitle
      ..languageResource = languageResource
      ..languageLocale = languageLocale
      ..docContent = docContent
      ..docUrl = docUrl;
  }
}

CommonInfoState initState(Map<String, dynamic>? args) {
  return CommonInfoState()..docUrl = args!['docUrl'];
}
