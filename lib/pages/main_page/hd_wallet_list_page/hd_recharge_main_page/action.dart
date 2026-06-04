import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HdRechargeMainAction { action, jump, loadBalance }

class HdRechargeMainActionCreator {
  static Action onAction() {
    return const Action(HdRechargeMainAction.action);
  }

  static Action onLoadBalance() {
    return const Action(HdRechargeMainAction.loadBalance);
  }

  static Action onJump(int index) {
    return Action(HdRechargeMainAction.jump, payload: index);
  }
}
