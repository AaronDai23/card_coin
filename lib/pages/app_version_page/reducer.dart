import 'package:fish_redux/fish_redux.dart';

import '../../widget/base_page_loading.dart';
import 'action.dart';
import 'bean/language_model.dart';
import 'state.dart';

Reducer<AppVersionState>? buildReducer() {
  return asReducer(
    <Object, Reducer<AppVersionState>>{
      AppVersionAction.init: _onInit,
      AppVersionAction.loadSuccess: _onLoadSuccess,
      AppVersionAction.loadFailure: _onLoadFailure,
      AppVersionAction.updateCurrentIndex: _onUpdateCurrentIndex,
    },
  );
}

AppVersionState _onInit(AppVersionState state, Action action) {
  final AppVersionState newState = state.clone()
    ..packageInfo = action.payload['packageInfo']
    ..userInfo = action.payload['userInfo'];
  return newState;
}

AppVersionState _onLoadSuccess(AppVersionState state, Action action) {
  List<LanguageModel> languageList = action.payload;
  var currentIndex = languageList.indexWhere((element) => element.locale == state.languageLocale.toString());
  if(currentIndex == -1){
    currentIndex = 0;
  }
  final AppVersionState newState = state.clone()
    ..languageList = action.payload
    ..currentIndex = currentIndex
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

AppVersionState _onLoadFailure(AppVersionState state, Action action) {
  final AppVersionState newState = state.clone()
    ..errorMsg = action.payload;
  return newState;
}

AppVersionState _onUpdateCurrentIndex(AppVersionState state, Action action) {
  final AppVersionState newState = state.clone()
    ..currentIndex = action.payload;
  return newState;
}