import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ErrorTipAction { action }

class ErrorTipActionCreator {
  static Action onAction() {
    return const Action(ErrorTipAction.action);
  }
}
