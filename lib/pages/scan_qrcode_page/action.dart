import 'package:fish_redux/fish_redux.dart';

enum ScanQrcodeAction { toggleTorchMode, turnFlash, pickImage }

class ScanQrcodeActionCreator {
  static Action onToggleTorchMode() {
    return const Action(ScanQrcodeAction.toggleTorchMode);
  }

  static Action onTurnFlash() {
    return const Action(ScanQrcodeAction.turnFlash);
  }

  static Action onPickImage() {
    return const Action(ScanQrcodeAction.pickImage);
  }
}
