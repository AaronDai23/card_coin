import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum UnlockPinCodeAction { action,confirmClick }

class UnlockPinCodeActionCreator {

  static Action onAction() {
    return const Action(UnlockPinCodeAction.action);
  }
  static Action onConfirmClick() {
    return const Action(UnlockPinCodeAction.confirmClick);
  }
}
