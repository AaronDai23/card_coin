import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvoiceEditAction {
  action,
  loadFlashUnit,
  showLoading,
  loadSuccess,
  loadFailed,
  dropdownSelect,
  update,
  textChanged,
  pressed,
  uploadInvoice,
}

class InvoiceEditActionCreator {
  static Action onAction() {
    return const Action(InvoiceEditAction.action);
  }

  static Action onLoadFlashUnit() {
    return const Action(InvoiceEditAction.loadFlashUnit);
  }

  static Action onShowLoading() {
    return const Action(InvoiceEditAction.showLoading);
  }

  static Action onLoadSuccess() {
    return const Action(InvoiceEditAction.loadSuccess);
  }

  static Action onUploadInvoice() {
    return const Action(InvoiceEditAction.uploadInvoice);
  }

  static Action onUpdate() {
    return const Action(InvoiceEditAction.update);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(InvoiceEditAction.loadFailed, payload: errorMsg);
  }

  static Action dropdownSelect(String content) {
    return Action(InvoiceEditAction.dropdownSelect, payload: content);
  }

  static Action onTextChanged(String text) {
    return Action(InvoiceEditAction.textChanged, payload: text);
  }

  static Action onPress() {
    return const Action(InvoiceEditAction.pressed);
  }
}
