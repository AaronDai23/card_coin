import 'package:fish_redux/fish_redux.dart';

import '../../../../managers/isodep_reader_manager.dart';

enum ResetCardDialogAction {
  startScan,
  onUpdateCount,
  onUpdateScanned,
  onUpdateShowInput,
  onUpdateCardNo,
  sendResetCommand,
  pwdBtnClick
}

class ResetCardDialogActionCreator {
  static Action onStartScan() {
    return const Action(ResetCardDialogAction.startScan);
  }

  static Action onPwdBtnClick() {
    return const Action(ResetCardDialogAction.pwdBtnClick);
  }

  static Action onUpdateCount(int value) {
    return Action(ResetCardDialogAction.onUpdateCount, payload: value);
  }

  static Action onUpdateScanned(bool value) {
    return Action(ResetCardDialogAction.onUpdateScanned, payload: value);
  }

  static Action onUpdateShowInput(bool isShow) {
    return Action(ResetCardDialogAction.onUpdateShowInput, payload: isShow);
  }

  static Action onUpdateCardNo(String cardNo) {
    return Action(ResetCardDialogAction.onUpdateCardNo, payload: cardNo);
  }

  static Action onSendResetCommand(IsoDepReaderManager isoDepReaderManager) {
    return Action(ResetCardDialogAction.sendResetCommand,
        payload: isoDepReaderManager);
  }
}
