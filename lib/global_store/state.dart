import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'states/app_language_resource.dart';

abstract class GlobalBaseState<T extends Cloneable<T>> implements Cloneable<T> {
  Locale? get languageLocale;
  set languageLocale(Locale? languageLocale);

  AppLanguageResource? get languageResource;
  set languageResource(AppLanguageResource? languageResource);
}

class GlobalState implements GlobalBaseState<GlobalState> {
  @override
  Locale? languageLocale;

  @override
  AppLanguageResource? languageResource;

  Map<String, dynamic>? languageData;

  bool? isInitBTC;

  @override
  GlobalState clone() {
    return GlobalState()
      ..languageData = languageData
      ..languageResource = languageResource
      ..isInitBTC = isInitBTC
      ..languageLocale = languageLocale;
  }
}
