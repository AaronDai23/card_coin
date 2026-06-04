import 'package:fish_redux/fish_redux.dart';

import '../../bean/system_config.dart';

//TODO replace with your own action
enum BindEmailAction {
  action,
  emailBindClick,
  sendEmailVerifiyCode,
  loadSuccess,
  loadFailed,
}

class BindEmailActionCreator {
  static Action onAction() {
    return const Action(BindEmailAction.action);
  }

  static Action onEmailBindClick() {
    return const Action(BindEmailAction.emailBindClick);
  }

  static Action onSendEmailVerifiyCode() {
    return const Action(BindEmailAction.sendEmailVerifiyCode);
  }

  static Action onLoadSuccess(SystemConfig systemConfig) {
    return Action(BindEmailAction.loadSuccess,payload: systemConfig);
  }

  static Action onLoadFailed(String errorMsg) {
    return Action(BindEmailAction.loadFailed,payload: errorMsg);
  }
}
