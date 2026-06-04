import 'package:fish_redux/fish_redux.dart';


//TODO replace with your own action
enum PhoneOtpAction { loginClick,sendLoginVerifyCode,updateCountry }

class PhoneOtpActionCreator {
  static Action onLoginClick() {
    return const Action(PhoneOtpAction.loginClick);
  }

  static Action onSendLoginVerifyCode() {
    return const Action(PhoneOtpAction.sendLoginVerifyCode);
  }

  static Action onUpdateCountry(int index) {
    return Action(PhoneOtpAction.updateCountry,payload: index);
  }
}
