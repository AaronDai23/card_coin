import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PhoneRegisterState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PhoneRegisterState>>{
      PhoneRegisterAction.updateCountry: _onUpdateCountry,
    },
  );
}

PhoneRegisterState _onUpdateCountry(PhoneRegisterState state, Action action) {
  final PhoneRegisterState newState = state.clone()..selectedIndex = action.payload;
  return newState;
}
