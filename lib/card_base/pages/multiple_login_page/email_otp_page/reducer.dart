import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<EmailOtpState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EmailOtpState>>{
      // EmailOtpAction.action: _onAction,
    },
  );
}
