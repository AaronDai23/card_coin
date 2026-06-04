import 'package:fish_redux/fish_redux.dart';

enum BackupDataAction { action, onScanCard }

class BackupDataActionCreator {
  static Action onAction() {
    return const Action(BackupDataAction.action);
  }

  static Action onScanCard() {
    return const Action(BackupDataAction.onScanCard);
  }
}
