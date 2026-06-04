import 'package:card_coin/card_base/bean/flow_progress_info_new.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentProcessAction {
  action,
  flowProgress,
  updateView,
  initialization,
  preActivateCard,
  loadDefaultCurrency,
  activateCard,
  preApprovalDCA,
  approvalDCA,
  scanCard,
  backClick,
  notificationback,
  signDCA,
  showLoading
}

class InvestmentProcessActionCreator {
  static Action onAction() {
    return const Action(InvestmentProcessAction.action);
  }

  static Action onApprovalDCA() {
    return const Action(InvestmentProcessAction.approvalDCA);
  }

  static Action onSignDCA() {
    return const Action(InvestmentProcessAction.signDCA);
  }

  static Action onInitialization() {
    return const Action(InvestmentProcessAction.initialization);
  }

  static Action onScanAction() {
    return const Action(InvestmentProcessAction.scanCard);
  }

  static Action onLoadDefaultCurrency() {
    return const Action(InvestmentProcessAction.loadDefaultCurrency);
  }

  static Action onFlowProgressAction() {
    return const Action(InvestmentProcessAction.flowProgress);
  }

  static Action onPreActivateCardAction() {
    return const Action(InvestmentProcessAction.preActivateCard);
  }

  static Action onPreProActivateCardAction() {
    return const Action(InvestmentProcessAction.preApprovalDCA);
  }

  static Action onUpdateCardAction(List<FlowProgressNewInfo> steps) {
    return Action(InvestmentProcessAction.updateView, payload: steps);
  }

  static Action onActivateCardAction() {
    return const Action(InvestmentProcessAction.activateCard);
  }

  static Action onBackClick() {
    return const Action(InvestmentProcessAction.backClick);
  }

  static Action onShowLoading() {
    return const Action(InvestmentProcessAction.showLoading);
  }

  static Action onNotificationBackClick() {
    return const Action(InvestmentProcessAction.notificationback);
  }
}
