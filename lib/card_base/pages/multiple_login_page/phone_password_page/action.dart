import 'package:fish_redux/fish_redux.dart';

import '../../../bean/country_register_info.dart';

//TODO replace with your own action
enum PhonePasswordAction { loginClick, updateCountry, updateCountryList }

class PhonePasswordActionCreator {
  static Action onLoginClick() {
    return const Action(PhonePasswordAction.loginClick);
  }

  static Action onUpdateCountry(int index) {
    return Action(PhonePasswordAction.updateCountry, payload: index);
  }

  static Action onUpdateCountryList(List<CountryRegisterInfo> countryList) {
    return Action(PhonePasswordAction.updateCountryList, payload: countryList);
  }
}
