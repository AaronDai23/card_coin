import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EmailRegisterAction { sendVerifyCode,registerClick,scanClick }

class EmailRegisterActionCreator {
  static Action onSendVerifyCode() {
    return const Action(EmailRegisterAction.sendVerifyCode);
  }

  static Action onRegisterClick() {
    return const Action(EmailRegisterAction.registerClick);
  }

  static Action onScanClick() {
    return const Action(EmailRegisterAction.scanClick);
  }
}
