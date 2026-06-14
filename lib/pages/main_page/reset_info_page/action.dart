import 'package:fish_redux/fish_redux.dart';

import '../../../bean/card_info_bean.dart';

enum ResetInfoAction {
  action,
  onResetFactorySettings,
  onCleanCache,
  loadCardInfo,
  loadSuccess,
  loadFailure,
}

class ResetInfoActionCreator {
  static Action onAction() {
    return const Action(ResetInfoAction.action);
  }

  static Action onResetFactorySettings() {
    return const Action(ResetInfoAction.onResetFactorySettings);
  }

  static Action onCleanCache() {
    return const Action(ResetInfoAction.onCleanCache);
  }

  static Action onLoadCardInfo() {
    return const Action(ResetInfoAction.loadCardInfo);
  }

  static Action onLoadSuccess(CardDetail? cardDetail) {
    return Action(ResetInfoAction.loadSuccess, payload: cardDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(ResetInfoAction.loadFailure, payload: errorMsg);
  }
}
