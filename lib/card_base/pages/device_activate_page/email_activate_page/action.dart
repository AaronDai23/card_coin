import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EmailActivateAction { action,updateStep,verifyEmail,showVerifyDialog,sendVerifyCode,activateClick,updateActivateInfo }

class EmailActivateActionCreator {

  static Action onActivateClick(String code) {
    return Action(EmailActivateAction.activateClick,payload: code);
  }

  static Action onUpdateStep(int step) {
    return Action(EmailActivateAction.updateStep,payload: step);
  }

  static Action onVerifyEmail() {
    return const Action(EmailActivateAction.verifyEmail);
  }

  static Action onSendVerifyCode() {
    return const Action(EmailActivateAction.sendVerifyCode);
  }

  static Action onShowVerifyDialog(int type) {
    return Action(EmailActivateAction.showVerifyDialog,payload: type);
  }

  static Action onUpdateActivateInfo(ActivateInfo activateInfo) {
    return Action(EmailActivateAction.updateActivateInfo,payload: activateInfo);
  }

}
