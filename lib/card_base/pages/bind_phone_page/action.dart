import 'package:fish_redux/fish_redux.dart';

import '../../bean/country_register_info.dart';

//TODO replace with your own action
enum BindPhoneAction {
  bindClick,
  sendVerifiyCode,
  updateCountry,
  loadCountryList,
  loadSuccess,
  loadFailed

}

class BindPhoneActionCreator {
  static Action onBindClick() {
    return const Action(BindPhoneAction.bindClick);
  }

  static Action onLoadCountryList() {
    return const Action(BindPhoneAction.loadCountryList);
  }

  static Action onLoadSuccess(List<CountryRegisterInfo> countryList) {
    return Action(BindPhoneAction.loadSuccess,payload: countryList);
  }

  static Action onLoadFailed(String error) {
    return Action(BindPhoneAction.loadFailed,payload: error);
  }

  static Action onSendVerifiyCode() {
    return const Action(BindPhoneAction.sendVerifiyCode);
  }

  static Action onUpdateCountry(int index) {
    return Action(BindPhoneAction.updateCountry,payload: index);
  }

}
