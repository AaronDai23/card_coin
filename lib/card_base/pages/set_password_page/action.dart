
import 'package:fish_redux/fish_redux.dart';

import '../../bean/setting_bean.dart';

//TODO replace with your own action
enum SetPasswordAction { loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  sendVerifiyCode,
  confirmClick,
  changeMethod,
  updateMethodIndex
}

class SetPasswordActionCreator {


  static Action onLoadSuccess(List<VerifyMethod> list) {
    return  Action(SetPasswordAction.loadSuccess,payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(SetPasswordAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(SetPasswordAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(SetPasswordAction.loadData);
  }
  static Action onSendVerifiyCode() {
    return const Action(SetPasswordAction.sendVerifiyCode);
  }

  static Action onConfirmClick() {
    return const Action(SetPasswordAction.confirmClick);
  }

  static Action onChangeMethod() {
    return const Action(SetPasswordAction.changeMethod);
  }

  static Action onUpdateMethodIndex(int index) {
    return Action(SetPasswordAction.updateMethodIndex,payload: index);
  }

}
