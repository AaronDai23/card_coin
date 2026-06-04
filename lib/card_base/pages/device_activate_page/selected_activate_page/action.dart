import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SelectedActivateAction { action,activateClick,cardActivateChanged }

class SelectedActivateActionCreator {

  static Action onAction() {
    return const Action(SelectedActivateAction.action);
  }

  static Action onActivateClick() {
    return const Action(SelectedActivateAction.activateClick);
  }

  static Action onCardActivateChanged(int activatePackageNum) {
    return Action(SelectedActivateAction.cardActivateChanged,payload: activatePackageNum);
  }
}
