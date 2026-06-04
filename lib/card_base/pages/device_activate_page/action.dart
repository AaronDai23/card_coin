import 'package:fish_redux/fish_redux.dart';

import '../../bean/validate_method.dart';

//TODO replace with your own action
enum DeviceActivateAction {
  action,
  loadSuccess,
  loadFailure,
  showLoading,
  showMethodList,
  changeType
}

class DeviceActivateActionCreator {

  static Action onAction() {
    return const Action(DeviceActivateAction.action);
  }
  static Action onLoadSuccess(List<ValidateMethod> validateMethodList) {
    return Action(DeviceActivateAction.loadSuccess,payload: validateMethodList);
  }
  static Action onLoadFailure(String errorMsg) {
    return Action(DeviceActivateAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(DeviceActivateAction.showLoading);
  }
  static Action onShowMethodList() {
    return const Action(DeviceActivateAction.showMethodList);
  }

  static Action onChangeType(int index) {
    return Action(DeviceActivateAction.changeType, payload: index);
  }
}
