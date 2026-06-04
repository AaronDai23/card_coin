import 'package:fish_redux/fish_redux.dart';

import '../../bean/country_register_info.dart';

//TODO replace with your own action
enum ForgotPasswordAction {
  action,
  sendClick,
  resetClick,
  updateCountry,
  loadCountryList,
  loadSuccess,
  loadFailed,
  switchType,
}

class ForgotPasswordActionCreator {
  static Action onAction() {
    return const Action(ForgotPasswordAction.action);
  }

  static Action onResetClick() {
    return const Action(ForgotPasswordAction.resetClick);
  }

  static Action onSendClick() {
    return const Action(ForgotPasswordAction.sendClick);
  }

  static Action onUpdateCountry(int index) {
    return Action(ForgotPasswordAction.updateCountry,
        payload: index);
  }

  static Action onLoadCountryList() {
    return const Action(ForgotPasswordAction.loadCountryList);
  }

  static Action onLoadSuccess(List<CountryRegisterInfo> countryList) {
    return Action(ForgotPasswordAction.loadSuccess, payload: countryList);
  }

  static Action onLoadFailed(String error) {
    return Action(ForgotPasswordAction.loadFailed, payload: error);
  }

  static Action onSwitchType(bool isPhone) {
    return Action(ForgotPasswordAction.switchType, payload: isPhone);
  }
}
