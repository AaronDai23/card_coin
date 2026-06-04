import 'package:fish_redux/fish_redux.dart';

class HdSendMainState implements Cloneable<HdSendMainState> {
  @override
  HdSendMainState clone() {
    return HdSendMainState();
  }
}

HdSendMainState initState(Map<String, dynamic>? args) {
  return HdSendMainState();
}
