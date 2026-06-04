import 'package:fish_redux/fish_redux.dart';

class PhoneActivateState implements Cloneable<PhoneActivateState> {

  @override
  PhoneActivateState clone() {
    return PhoneActivateState();
  }
}

PhoneActivateState initState(Map<String, dynamic>? args) {
  return PhoneActivateState();
}
