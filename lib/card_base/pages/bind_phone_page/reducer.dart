import 'package:fish_redux/fish_redux.dart';

import '../../../widget/base_page_loading.dart';
import '../../bean/country_register_info.dart';
import 'action.dart';
import 'state.dart';

Reducer<BindPhoneState>? buildReducer() {
  return asReducer(
    <Object, Reducer<BindPhoneState>>{
      BindPhoneAction.loadFailed: _onLoadFailed,
      BindPhoneAction.loadSuccess: _onLoadSuccess,
      BindPhoneAction.updateCountry: _onUpdateCountry,
    },
  );
}

BindPhoneState _onUpdateCountry(BindPhoneState state, Action action) {
  final BindPhoneState newState = state.clone()..selectedIndex = action.payload;
  return newState;
}

BindPhoneState _onLoadFailed(BindPhoneState state, Action action) {
  final BindPhoneState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}

BindPhoneState _onLoadSuccess(BindPhoneState state, Action action) {
  List<CountryRegisterInfo> countryList = action.payload;
  final BindPhoneState newState = state.clone()
    ..countryList = countryList
    ..loadStatus = LoadType.loadSuccess;
  return newState;
}
