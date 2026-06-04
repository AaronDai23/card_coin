import 'package:fish_redux/fish_redux.dart';

enum DeviceSettingsAction { action, scanClick, updateImage }

class DeviceSettingsActionCreator {
  static Action onAction() {
    return const Action(DeviceSettingsAction.action);
  }

  static Action onScanClick() {
    return const Action(DeviceSettingsAction.scanClick);
  }

  static Action onUpdateImage() {
    return const Action(DeviceSettingsAction.updateImage);
  }
}
