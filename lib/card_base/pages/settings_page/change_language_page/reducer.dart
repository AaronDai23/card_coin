import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ChangeLanguageState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ChangeLanguageState>>{
      ChangeLanguageAction.action: _onAction,
      ChangeLanguageAction.loadFailure: _onLoadFailure,
      ChangeLanguageAction.loadSuccess: _onLoadSuccess,
    },
  );
}

ChangeLanguageState _onAction(ChangeLanguageState state, Action action) {
  final ChangeLanguageState newState = state.clone();
  return newState;
}

ChangeLanguageState _onLoadFailure(ChangeLanguageState state, Action action) {
  String errorMsg = action.payload;
  final ChangeLanguageState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = errorMsg;
  return newState;
}

ChangeLanguageState _onLoadSuccess(ChangeLanguageState state, Action action) {
  final ChangeLanguageState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..languageList = action.payload;
  return newState;
}
