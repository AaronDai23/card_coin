
import 'package:fish_redux/fish_redux.dart';

import '../../bean/common_info_bean.dart';

//TODO replace with your own action
enum CommonInfoAction { action,loadSuccess,loadFailure,showLoading,loadData }

class CommonInfoActionCreator {
  static Action onAction() {
    return const Action(CommonInfoAction.action);
  }

  static Action onLoadSuccess(CommonInfo commonInfo) {
    return Action(CommonInfoAction.loadSuccess,payload: commonInfo);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(CommonInfoAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(CommonInfoAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(CommonInfoAction.loadData);
  }
}
