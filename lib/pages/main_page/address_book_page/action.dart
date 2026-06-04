import 'package:card_coin/bean/address_book_info.dart';
import 'package:fish_redux/fish_redux.dart';

enum AddressBookAction {
  onInit,
  onLoadFailure,
  onAdd,
  onEdit,
  onDelete,
  onCopyAddress,
  onUpdateItems,
}

class AddressBookActionCreator {
  static Action onInit(List<AddressBookInfo> value) {
    return Action(AddressBookAction.onInit, payload: value);
  }

  static Action onLoadFailure(String value) {
    return Action(AddressBookAction.onLoadFailure, payload: value);
  }

  static Action onAdd() {
    return const Action(AddressBookAction.onAdd);
  }

  static Action onEdit(int value) {
    return Action(AddressBookAction.onEdit, payload: value);
  }

  static Action onDelete(int value) {
    return Action(AddressBookAction.onDelete, payload: value);
  }



  static Action onCopyAddress(String value) {
    return Action(AddressBookAction.onCopyAddress, payload: value);
  }

  static Action onUpdateItems(List<AddressBookInfo> value) {
    return Action(AddressBookAction.onUpdateItems, payload: value);
  }
}
