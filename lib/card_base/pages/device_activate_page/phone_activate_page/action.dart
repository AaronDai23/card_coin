import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PhoneActivateAction { action }

class PhoneActivateActionCreator {
  static Action onAction() {
    return const Action(PhoneActivateAction.action);
  }
}
