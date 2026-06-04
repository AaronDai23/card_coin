import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PhoneRegisterAction {
  sendVerifyCode,
  registerClick,
  scanClick,
  updateCountryList,
  updateCountry,
}

class PhoneRegisterActionCreator {
  static Action onSendVerifyCode() {
    return const Action(PhoneRegisterAction.sendVerifyCode);
  }

  static Action onRegisterClick() {
    return const Action(PhoneRegisterAction.registerClick);
  }

  static Action onUpdateCountry(int index) {
    return Action(PhoneRegisterAction.updateCountry,payload: index);
  }

  static Action onScanClick() {
    return const Action(PhoneRegisterAction.scanClick);
  }

  static Action onUpdateCountryList() {
    return const Action(PhoneRegisterAction.updateCountryList);
  }
}
