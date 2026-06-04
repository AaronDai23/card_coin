import 'package:card_coin/utils/runnable/bean/pin_code_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PinCodeInfoAction { action,setPinCode,updatePinCode,updatePinCodeInfo,cancelPinCode }

class PinCodeInfoActionCreator {

  static Action onSetPinCode() {
    return const Action(PinCodeInfoAction.setPinCode);
  }

  static Action onUpdatePinCode() {
    return const Action(PinCodeInfoAction.updatePinCode);
  }

  static Action onUpdatePinCodeInfo(PinCodeInfo pinCodeInfo) {
    return Action(PinCodeInfoAction.updatePinCodeInfo,payload: pinCodeInfo);
  }
  static Action onCancelPinCode() {
    return const Action(PinCodeInfoAction.cancelPinCode);
  }
}
