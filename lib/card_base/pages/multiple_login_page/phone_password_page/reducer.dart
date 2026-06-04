import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PhonePasswordState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PhonePasswordState>>{
      // PhonePasswordAction.action: _onAction,
      PhonePasswordAction.updateCountry: _onUpdateCountry,
      PhonePasswordAction.updateCountryList: _onUpdateCountryList,
    },
  );
}

PhonePasswordState _onUpdateCountry(PhonePasswordState state, Action action) {
  final PhonePasswordState newState = state.clone()
    ..selectedIndex = action.payload;
  return newState;
}

PhonePasswordState _onUpdateCountryList(
    PhonePasswordState state, Action action) {
  final PhonePasswordState newState = state.clone()
    ..countryList = action.payload
    ..selectedIndex = 0;
  return newState;
}
