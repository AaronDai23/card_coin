import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/widget/base_page_loading.dart';

class PackageActivateState extends LoadPageState<PackageActivateState> {
  late String uid;
  ActivatePackageSummary? activateSummary;
  List<CardPackage> packageList = [];
  List<int> selectedList = [];
  @override
  PackageActivateState clone() {
    return PackageActivateState()..uid = uid
      ..activateSummary = activateSummary
      ..languageResource = languageResource
      ..packageList = packageList
      ..selectedList = selectedList
      ..loadStatus = loadStatus
      ..errorMsg = errorMsg;
  }
}

PackageActivateState initState(Map<String, dynamic>? args) {
  return PackageActivateState()..uid = args!['uid'];
}
