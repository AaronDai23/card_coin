import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum BiometricsAction {
  action,
  showLoading,
  loadSuccess,
  loadFailed,
  toggleBiometric,
  bindBiometricStatus,
  unBindBiometricStatus,
  bindBiometricDetail,
  
}

class BiometricsActionCreator {
  static Action onAction() {
    return const Action(BiometricsAction.action);
  }

  static Action onShowLoading() {
    return const Action(BiometricsAction.showLoading);
  }

  static Action onLoadSuccess(bool isOpen) {
    return Action(BiometricsAction.loadSuccess, payload: isOpen);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(BiometricsAction.loadFailed, payload: errorMsg);
  }

  static Action onToggleBiometric() {
    return const Action(BiometricsAction.toggleBiometric);
  }

  static Action onBindBiometricStatus() {
    return const Action(BiometricsAction.bindBiometricStatus);
  }

  static Action onUnBindBiometricStatus() {
    return const Action(BiometricsAction.unBindBiometricStatus);
  }

  static Action onBindBiometricDetail() {
    return const Action(BiometricsAction.bindBiometricDetail);
  }
}
