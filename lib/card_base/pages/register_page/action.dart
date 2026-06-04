import 'package:card_coin/card_base/bean/login_bean.dart';
import 'package:fish_redux/fish_redux.dart';


//TODO replace with your own action
enum RegisterAction {
  sendVerificationCode,
  loadCountryList,
  registerClick,
  updateAgree,
  scanClick,
  changeType,
  showRegisterList,
  registerAccount,
  loadSuccess,
  loadFailed,
}

class RegisterActionCreator {
  static Action onRegisterClick() {
    return const Action(
      RegisterAction.registerClick,
    );
  }

  static Action onLoadCountryList() {
    return const Action(RegisterAction.loadCountryList);
  }

  static Action onLoadSuccess(List<LoginMethod> registerMethodList) {
    return Action(RegisterAction.loadSuccess, payload: registerMethodList);
  }

  static Action onLoadFailed(String error) {
    return Action(RegisterAction.loadFailed, payload: error);
  }

  static Action onUpdateAgree(bool isAgree) {
    return Action(RegisterAction.updateAgree, payload: isAgree);
  }

  static Action onChangeType(int index) {
    return Action(RegisterAction.changeType, payload: index);
  }

  static Action onShowRegisterList() {
    return const Action(RegisterAction.showRegisterList);
  }

  static Action onRegisterAccount(int index) {
    return Action(RegisterAction.registerAccount, payload: index);
  }
}
