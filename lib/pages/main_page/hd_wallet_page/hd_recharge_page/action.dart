import 'package:card_coin/bean/blockchain/bit_coin_transaction_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HdRechargeAction {
  action,
  showLoading,
  loadSuccess,
  loadFailed,
  showNetworks,
  update,
  back
}

class HdRechargeActionCreator {
  static Action onAction() {
    return const Action(HdRechargeAction.action);
  }

  static Action onBack() {
    return const Action(HdRechargeAction.back);
  }

  static Action onUpdate(CurrencyInfo currency) {
    return Action(HdRechargeAction.update, payload: currency);
  }

  static Action onShowLoading() {
    return const Action(HdRechargeAction.showLoading);
  }

  static Action onShowNetworks() {
    return const Action(HdRechargeAction.showNetworks);
  }

  static Action onLoadSuccess(CurrencyInfo currency) {
    return Action(HdRechargeAction.loadSuccess, payload: currency);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(HdRechargeAction.loadFailed, payload: errorMsg);
  }
}
