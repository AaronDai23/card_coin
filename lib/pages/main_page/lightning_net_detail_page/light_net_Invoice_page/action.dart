import 'package:card_coin/bean/invoice_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum LightNetInvoiceAction {
  editAction,
  copy,
  showLoading,
  loadSuccess,
  loadFailed,
  loadData
}

class LightNetInvoiceActionCreator {
  static Action editOnAction() {
    return const Action(LightNetInvoiceAction.editAction);
  }

  static Action copyOnAction() {
    return const Action(LightNetInvoiceAction.copy);
  }

  static Action onShowLoading() {
    return const Action(LightNetInvoiceAction.showLoading);
  }

  static Action onLoadSuccess(InvoiceInfo invoiceInfo) {
    return Action(LightNetInvoiceAction.loadSuccess, payload: invoiceInfo);
  }

  static Action onLoadData() {
    return const Action(LightNetInvoiceAction.loadData);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(LightNetInvoiceAction.loadFailed, payload: errorMsg);
  }
}
