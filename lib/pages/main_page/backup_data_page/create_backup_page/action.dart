import 'package:fish_redux/fish_redux.dart';

enum CreateBackupAction { action, onAddBackUpCard }

class CreateBackupActionCreator {
  static Action onAction() {
    return const Action(CreateBackupAction.action);
  }

  static Action onAddBackUpCard() {
    return const Action(CreateBackupAction.onAddBackUpCard);
  }
}
