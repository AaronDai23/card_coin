import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AllActivateAction { action,loadSuccess,loadFailure,showLoading,activateClick }

class AllActivateActionCreator {
  static Action onAction() {
    return const Action(AllActivateAction.action);
  }

  static Action onLoadSuccess(ActivateSummary summaryInfo) {
    return Action(AllActivateAction.loadSuccess,payload: summaryInfo);
  }
  static Action onLoadFailure(String errorMsg) {
    return Action(AllActivateAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(AllActivateAction.showLoading);
  }
  static Action onActivateClick() {
    return const Action(AllActivateAction.activateClick);
  }
}
