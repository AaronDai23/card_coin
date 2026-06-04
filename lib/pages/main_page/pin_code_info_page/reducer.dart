import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PinCodeInfoState>? buildReducer() {
  return asReducer(
    <Object, Reducer<PinCodeInfoState>>{
      PinCodeInfoAction.updatePinCodeInfo: _onUpdatePinCodeInfo,
    },
  );
}

PinCodeInfoState _onUpdatePinCodeInfo(PinCodeInfoState state, Action action) {
  final PinCodeInfoState newState = state.clone()..pinCodeInfo = action.payload;
  return newState;
}
