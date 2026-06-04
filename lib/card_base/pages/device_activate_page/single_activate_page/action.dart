import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SingleActivateAction { action,loadSuccess,loadFailure,showLoading,scanClick }

class SingleActivateActionCreator {
  static Action onAction() {
    return const Action(SingleActivateAction.action);
  }

  static Action onLoadSuccess(ActivateSummary summaryInfo) {
    return Action(SingleActivateAction.loadSuccess,payload: summaryInfo);
  }
  static Action onLoadFailure(String errorMsg) {
    return Action(SingleActivateAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(SingleActivateAction.showLoading);
  }
  static Action onScanClick() {
    return const Action(SingleActivateAction.scanClick);
  }
}
