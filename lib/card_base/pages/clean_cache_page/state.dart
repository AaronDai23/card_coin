import 'dart:ui';

import 'package:card_coin/global_store/state.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:fish_redux/fish_redux.dart';

class CleanCacheState
    implements Cloneable<CleanCacheState>, GlobalBaseState<CleanCacheState> {
  String cardId = '';
  bool isClearing = false;

  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  @override
  CleanCacheState clone() {
    return CleanCacheState()
      ..cardId = cardId
      ..isClearing = isClearing
      ..languageLocale = languageLocale
      ..languageResource = languageResource;
  }
}

CleanCacheState initState(Map<String, dynamic>? args) {
  return CleanCacheState()..cardId = args?['cardId'] ?? '';
}
