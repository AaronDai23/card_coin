import 'package:fish_redux/fish_redux.dart';

import '../light_net_Invoice_page/invoice_edit_page/bean/unit_info.dart';

enum WithdrawLightningAction { action, loadSuccess, loadFailed, unitChanged, amountChanged,withdrawClick,update }

class WithdrawLightningActionCreator {
  static Action onAction() {
    return const Action(WithdrawLightningAction.action);
  }

  static Action onLoadSuccess(List<UnitInfo> list) {
    return Action(WithdrawLightningAction.loadSuccess, payload: list);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(WithdrawLightningAction.loadFailed, payload: errorMsg);
  }

  static Action onUnitChanged(UnitInfo? unitInfo) {
    return Action(WithdrawLightningAction.unitChanged, payload: unitInfo);
  }

  static Action onAmountChanged(String amount) {
    return Action(WithdrawLightningAction.amountChanged, payload: amount);
  }

  static Action onWithdrawClick() {
    return const Action(WithdrawLightningAction.withdrawClick);
  }

  static Action onUpdate() {
    return const Action(WithdrawLightningAction.update);
  }
}
