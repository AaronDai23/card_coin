import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ActivateDetailAction { action,activateClick,updateTitle }

class ActivateDetailActionCreator {

  static Action onAction() {
    return const Action(ActivateDetailAction.action);
  }

  static Action onActivateClick() {
    return const Action(ActivateDetailAction.activateClick);
  }

  static Action onUpdateTitle(String? title) {
    return Action(ActivateDetailAction.updateTitle,payload: title);
  }
}
