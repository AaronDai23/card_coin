import 'package:fish_redux/fish_redux.dart';

import '../../bean/login_bean.dart';

//TODO replace with your own action
enum MultipleLoginAction {
  jump,
  emailLogin,
  phoneLogin,
  register,
  loginTypeClick,
  updateLoginType,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  scanLogin,
  faceLogin
}

class MultipleLoginActionCreator {
  static Action onJump(int index) {
    return Action(MultipleLoginAction.jump, payload: index);
  }

  static Action onEmailLogin() {
    return const Action(MultipleLoginAction.emailLogin);
  }

  static Action onPhoneLogin() {
    return const Action(MultipleLoginAction.phoneLogin);
  }

  static Action onRegister() {
    return const Action(MultipleLoginAction.register);
  }

  static Action onLoginTypeClick(LoginMethod method) {
    return Action(MultipleLoginAction.loginTypeClick, payload: method);
  }

  static Action onUpdateLoginType(int index) {
    return Action(MultipleLoginAction.updateLoginType, payload: index);
  }

  static Action onLoadSuccess(List<LoginMethod> list) {
    return Action(MultipleLoginAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MultipleLoginAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MultipleLoginAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(MultipleLoginAction.loadData);
  }

  static Action onScanLogin() {
    return const Action(MultipleLoginAction.scanLogin);
  }

  static Action onFaceLogin() {
    return const Action(MultipleLoginAction.faceLogin);
  }
}
