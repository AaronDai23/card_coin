import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<CancelPinCodeState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CancelPinCodeState>>{
      // CancelPinCodeAction.action: _onAction,
    },
  );
}
