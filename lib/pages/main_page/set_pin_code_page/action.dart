import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SetPinCodeAction { action,setPinCodeClick,cancelPinCode }

class SetPinCodeActionCreator {

  static Action onAction() {
    return const Action(SetPinCodeAction.action);
  }

  static Action onSetPinCodeClick() {
    return const Action(SetPinCodeAction.setPinCodeClick);
  }

  static Action onCancelPinCode() {
    return const Action(SetPinCodeAction.cancelPinCode);
  }
}
