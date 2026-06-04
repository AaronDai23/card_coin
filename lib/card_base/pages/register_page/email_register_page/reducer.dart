import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<EmailRegisterState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EmailRegisterState>>{
      // EmailRegisterAction.action: _onAction,
    },
  );
}
