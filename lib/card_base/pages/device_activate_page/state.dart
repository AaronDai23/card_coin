

import '../../../widget/base_page_loading.dart';
import '../../bean/validate_method.dart';

class DeviceActivateState extends LoadPageState<DeviceActivateState> {

  late String uuid;
  List<ValidateMethod>? validateMethodList;
  int currentIndex = 0;
  late String title;
  @override
  DeviceActivateState clone() {
    return DeviceActivateState()
      ..uuid = uuid
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg
      ..title = title
      ..currentIndex = currentIndex
      ..validateMethodList = validateMethodList
    ;

  }

}

DeviceActivateState initState(Map<String, dynamic>? args) {
  return DeviceActivateState()
    ..uuid = args!['uuid']
    ..title = args['title']??''
  ;
}
