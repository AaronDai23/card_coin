import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EditCardAction { setMainClick,updateNameClick,updateCardInfo }

class EditCardActionCreator {

  static Action onSetMainClick() {
    return const Action(EditCardAction.setMainClick);
  }

  static Action onUpdateNameClick() {
    return const Action(EditCardAction.updateNameClick);
  }

  static Action onUpdateCardInfo() {
    return const Action(EditCardAction.updateCardInfo);
  }
}
