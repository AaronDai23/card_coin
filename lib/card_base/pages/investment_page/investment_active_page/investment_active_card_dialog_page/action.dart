import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentActiveCardDialogAction {
  action,
  startScan,
  onUpdateCount,
  onUpdateScanned,
  onUpdateShowInput,
  sendResetCommand,
  pwdBtnClick
}

class InvestmentActiveCardDialogActionCreator {
  static Action onAction() {
    return const Action(InvestmentActiveCardDialogAction.action);
  }

  static Action onStartScan() {
    return const Action(InvestmentActiveCardDialogAction.startScan);
  }

  static Action onPwdBtnClick() {
    return const Action(InvestmentActiveCardDialogAction.pwdBtnClick);
  }

  static Action onUpdateCount(int value) {
    return Action(InvestmentActiveCardDialogAction.onUpdateCount,
        payload: value);
  }

  static Action onUpdateScanned(bool value) {
    return Action(InvestmentActiveCardDialogAction.onUpdateScanned,
        payload: value);
  }

  static Action onUpdateShowInput(bool isShow) {
    return Action(InvestmentActiveCardDialogAction.onUpdateShowInput,
        payload: isShow);
  }

  static Action onSendResetCommand(String isoDepReaderManager) {
    return Action(InvestmentActiveCardDialogAction.sendResetCommand,
        payload: isoDepReaderManager);
  }
}
