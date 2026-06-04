import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PhoneOtpState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PhoneOtpState>>{
      // PhoneOtpAction.action: _onAction,
      PhoneOtpAction.updateCountry: _onUpdateCountry,
    },
  );
}

PhoneOtpState _onUpdateCountry(PhoneOtpState state, Action action) {
  final PhoneOtpState newState = state.clone()..selectedIndex = action.payload;
  return newState;
}
