import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EmailOtpAction { loginClick,sendLoginVerifyCode }

class EmailOtpActionCreator {

  static Action onLoginClick() {
    return const Action(EmailOtpAction.loginClick);
  }

  static Action onSendLoginVerifyCode() {
    return const Action(EmailOtpAction.sendLoginVerifyCode);
  }

}
