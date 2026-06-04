import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/card_base/bean/card_group_bean.dart';
import 'package:fish_redux/fish_redux.dart';


//TODO replace with your own action
enum GroupCardDetailAction {
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  showDeleteDialog,
  refreshHoldCard,
  showDetailDialog,
  itemClick,
  deletedUpateCardDetail,
  pushInvestmentActvite,
  investmentlist
}

class GroupCardDetailActionCreator {
  static Action onLoadSuccess(SmartCardListInfo smartCardListInfo,
      {bool isMore = false}) {
    return Action(GroupCardDetailAction.loadSuccess,
        payload: {'smartCardListInfo': smartCardListInfo, 'isMore': isMore});
  }

  static Action onRefreshHoldCard() {
    return const Action(GroupCardDetailAction.refreshHoldCard);
  }

  static Action onItemClick(String cardId) {
    return Action(GroupCardDetailAction.itemClick, payload: cardId);
  }

  static Action onShowDetailDialog(SmartCardDetail cardDetail) {
    return Action(GroupCardDetailAction.showDetailDialog, payload: cardDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(GroupCardDetailAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(GroupCardDetailAction.showLoading);
  }

  static Action onLoadData({bool isLoadMore = false}) {
    return Action(GroupCardDetailAction.loadData, payload: isLoadMore);
  }

  static Action onShowDeleteDialog(SmartCardDetail cardDetail) {
    return Action(GroupCardDetailAction.showDeleteDialog, payload: cardDetail);
  }

  static Action onDeletedUpateCardDetail(String smartCardId) {
    return Action(GroupCardDetailAction.deletedUpateCardDetail,
        payload: smartCardId);
  }

  static Action onPushInvestmentActviteClick(SmartCardDetail cardDetail) {
    return Action(GroupCardDetailAction.pushInvestmentActvite,
        payload: cardDetail);
  }

  static Action onInvestmentPage(SmartCardDetail cardDetail) {
    return Action(GroupCardDetailAction.investmentlist, payload: cardDetail);
  }
}
