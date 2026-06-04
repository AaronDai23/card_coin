import 'package:fish_redux/fish_redux.dart';

import '../../../bean/card_info_bean.dart';

//TODO replace with your own action
enum CreateNewWalletAction {
  action,
  loadCardInfo,
  loadSuccess,
  loadFailure,
  createWalletClick
}

class CreateNewWalletActionCreator {
  static Action onAction() {
    return const Action(CreateNewWalletAction.action);
  }

  static Action onLoadCardInfo(CardInfo cardInfo) {
    return Action(CreateNewWalletAction.loadCardInfo, payload: cardInfo);
  }

  static Action onLoadSuccess(CardDetail? cardDetail) {
    return Action(CreateNewWalletAction.loadSuccess, payload: cardDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(CreateNewWalletAction.loadFailure, payload: errorMsg);
  }

  static Action onCreateWalletClick() {
    return const Action(CreateNewWalletAction.createWalletClick);
  }
}
