import 'package:card_coin/bean/health_check_bean.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum CheckCardAction {
  initTask,
  updateCheckInfoList,
  updateShowScan,
  startCheck,
  upload,
  resetScan,
}

class CheckCardActionCreator {
  static Action onInitTask(List<HealthCheckInfo> checkList) {
    return Action(CheckCardAction.initTask, payload: checkList);
  }

  static Action onUpdateCheckInfoList(List<HealthCheckInfo> checkList) {
    return Action(CheckCardAction.updateCheckInfoList, payload: checkList);
  }

  static Action onUpdateShowScan(bool isShow) {
    return Action(CheckCardAction.updateShowScan, payload: isShow);
  }

  static Action onStartAction() {
    return const Action(CheckCardAction.startCheck);
  }

  static Action onReSetAction() {
    return const Action(CheckCardAction.resetScan);
  }

  static Action onUploadAction(String cardId) {
    return Action(CheckCardAction.upload, payload: cardId);
  }
}
