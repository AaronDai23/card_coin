import 'dart:ui';

import 'package:card_coin/global_store/states/app_language_resource.dart';

import '../../../global_store/state.dart';

class ActivateDetailState implements GlobalBaseState<ActivateDetailState> {
  String? uuid;
  String? title;
  @override
  ActivateDetailState clone() {
    return ActivateDetailState()
      ..uuid = uuid
      ..title = title
      ..languageLocale = languageLocale
      ..languageResource = languageResource
    ;
  }

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;
}

ActivateDetailState initState(Map<String, dynamic>? args) {
  return ActivateDetailState()
    ..uuid = args!['uuid']
    ..title = args['title']
  ;
}
