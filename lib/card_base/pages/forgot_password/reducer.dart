import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<ForgotPasswordState>? buildReducer() {
  return asReducer(
    <Object, Reducer<ForgotPasswordState>>{
      ForgotPasswordAction.action: _onAction,
      ForgotPasswordAction.updateCountry: _onUpdateCountryInfo,
      ForgotPasswordAction.loadSuccess: _onLoadSuccess,
      ForgotPasswordAction.loadFailed: _onLoadFailed,
      ForgotPasswordAction.switchType: _onSwitchType,
    },
  );
}

ForgotPasswordState _onAction(ForgotPasswordState state, Action action) {
  final ForgotPasswordState newState = state.clone();
  return newState;
}

ForgotPasswordState _onLoadSuccess(ForgotPasswordState state, Action action) {
  List<CountryRegisterInfo> countryList = action.payload;

  final ForgotPasswordState newState = state.clone()
    ..countryList = countryList
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}

ForgotPasswordState _onLoadFailed(ForgotPasswordState state, Action action) {
  final ForgotPasswordState newState = state.clone()
    ..errorMsg = action.payload
    ..loadStatus = LoadType.loadFailure;
  return newState;
}

ForgotPasswordState _onUpdateCountryInfo(ForgotPasswordState state, Action action) {
  final ForgotPasswordState newState = state.clone()
    ..selectedIndex = action.payload
  ;
  return newState;
}

ForgotPasswordState _onSwitchType(ForgotPasswordState state, Action action) {
  final ForgotPasswordState newState = state.clone()
    ..isPhone = action.payload
  ;
  return newState;
}
