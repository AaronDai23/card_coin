
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;

import '../generated/l10n.dart';
import 'action.dart';
import 'state.dart';

Reducer<GlobalState> buildReducer() {
  return asReducer(
    <Object, Reducer<GlobalState>>{
      GlobalAction.changeLanguage: _onChangeLanguage,
      GlobalAction.initLocalization: _onInitLocalization,
    },
  )!;
}


GlobalState _onChangeLanguage(GlobalState state, Action action) {
  Locale locale = action.payload;
  const AppLocalizationDelegate().load(locale);
  AppLanguageResource languageResource;
  if(state.languageData != null){
    var currentLanguageData = state.languageData![locale.toString()];
    currentLanguageData ??= state.languageData![const Locale('en', 'US').toString()];
    currentLanguageData ??= <String,dynamic>{};
    languageResource = AppLanguageResource(currentLanguageData);
  }else{
    languageResource = AppLanguageResource({});
  }
  return state.clone()
    ..languageLocale = locale
    ..languageResource = languageResource
  ;
}

GlobalState _onInitLocalization(GlobalState state, Action action) {
  String languageString;
  if(state.languageLocale != null){
    languageString = '${state.languageLocale?.languageCode}_${state.languageLocale?.countryCode}';
  }else{
    languageString = 'en_US';
  }
  print('_onInitLocalization:$languageString');
  Map<String,dynamic> languageData = action.payload;
  var languageMessage = action.payload[languageString];

  AppLanguageResource languageResource = AppLanguageResource(languageMessage??<String,dynamic>{});
  return state.clone()
    ..languageData = languageData
    ..languageResource = languageResource

  ;
}
