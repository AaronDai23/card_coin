import 'dart:ui';

import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';

class SelectedActivateState implements GlobalBaseState<SelectedActivateState> {
  late String uid;
  late List<CardPackage> packageList;
  @override
  SelectedActivateState clone() {
    return SelectedActivateState()
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..uid = uid
      ..packageList = packageList;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

SelectedActivateState initState(Map<String, dynamic>? args) {
  return SelectedActivateState()
    ..packageList = args!['packageList']
    ..uid = args['uid']
  ;
}
