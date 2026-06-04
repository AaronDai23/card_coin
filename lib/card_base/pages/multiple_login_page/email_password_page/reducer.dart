import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<EmailPasswordState>? buildReducer() {
  return asReducer(
    <Object, Reducer<EmailPasswordState>>{
      // EmailPasswordAction.action: _onAction,
    },
  );
}
