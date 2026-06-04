import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum CancelPinCodeAction { confirmClick }

class CancelPinCodeActionCreator {
  static Action onConfirmClick() {
    return const Action(CancelPinCodeAction.confirmClick);
  }
}
