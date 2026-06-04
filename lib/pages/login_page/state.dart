import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

class LoginState implements Cloneable<LoginState> {
  late TextEditingController phoneController;
  late TextEditingController pwdController;
  late FocusNode focusNodePhone;
  late FocusNode focusNodePwd;

  late bool showPwd;
  late bool keepPwd;

  @override
  LoginState clone() {
    return LoginState()
      ..showPwd = showPwd
      ..keepPwd = keepPwd
      ..phoneController = phoneController
      ..pwdController = pwdController
      ..focusNodePhone = focusNodePhone
      ..focusNodePwd = focusNodePwd;
  }
}

LoginState initState(Map<String, dynamic>? args) {
  return LoginState()
    ..showPwd = false
    ..keepPwd = true
    ..focusNodePhone = FocusNode()
    ..focusNodePwd = FocusNode()
    ..phoneController = TextEditingController(text: '')
    ..pwdController = TextEditingController(text: '');
}
