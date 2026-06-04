import 'package:fish_redux/fish_redux.dart';

import '../../../../global_store/states/app_language_resource.dart';

class ScanState implements Cloneable<ScanState> {
  late AppLanguageResource languageResource;
  @override
  ScanState clone() {
    return ScanState()..languageResource = languageResource;
  }
}
