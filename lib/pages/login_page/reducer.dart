import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LoginState>? buildReducer() {
  return asReducer(
    <Object, Reducer<LoginState>>{
      LoginAction.action: _onAction,
      LoginAction.showPwd:_onShowPwd,
      LoginAction.keepPwdClick:_onKeepPwdClick,
    },
  );
}

LoginState _onAction(LoginState state, Action action) {
  final LoginState newState = state.clone();
  return newState;
}

LoginState _onShowPwd(LoginState state, Action action) {
  final LoginState newState = state.clone()..showPwd = action.payload;
  return newState;
}

LoginState _onKeepPwdClick(LoginState state, Action action) {
  final LoginState newState = state.clone()..keepPwd = !state.keepPwd;
  return newState;
}
