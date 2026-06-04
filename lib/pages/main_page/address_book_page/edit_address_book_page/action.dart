import 'package:fish_redux/fish_redux.dart';

enum EditAddressBookAction { action, onSave }

class EditAddressBookActionCreator {
  static Action onAction() {
    return const Action(EditAddressBookAction.action);
  }

  static Action onSave() {
    return const Action(EditAddressBookAction.onSave);
  }
}
