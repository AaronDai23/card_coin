import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EmailPasswordAction { loginClick }

class EmailPasswordActionCreator {
  static Action onLoginClick() {
    return const Action(EmailPasswordAction.loginClick);
  }
}
