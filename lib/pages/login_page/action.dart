import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum LoginAction { action,login,showPwd,loadData,loginSuccess,loginFromRegister,keepPwdClick }

class LoginActionCreator {
  static Action onAction() {
    return const Action(LoginAction.action);
  }

  static Action onLoginSuccess(String token) {
    return Action(LoginAction.loginSuccess,payload: token);
  }

  static Action onLogin() {
    return const Action(LoginAction.login);
  }

  static Action onLoginFromRegister(String phone,String password) {
    var map = <String,dynamic>{};
    map['phone'] = phone;
    map['password'] = password;
    return Action(LoginAction.loginFromRegister,payload: map);
  }

  static Action onShowPwd(bool isShow) {
    return Action(LoginAction.showPwd,payload: isShow);
  }

  static Action onKeepPwdClick() {
    return const Action(LoginAction.keepPwdClick);
  }
}
