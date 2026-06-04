import 'package:fish_redux/fish_redux.dart';

import '../../../../bean/banner_bean.dart';

//TODO replace with your own action
enum TabWalletAction {
  loadData,
  loadSuccess,
  loadFailure,
  showLoading,
  scanCard,
  deleteItem,
  updateCardInfo,
  setCardAmount,
  updateIndex,
  bannerItemClick,
  updateUnReadCount,
  reloadMainData
}

class TabWalletActionCreator {
  static Action onUpdateUnReadCount(int count) {
    return Action(TabWalletAction.updateUnReadCount, payload: count);
  }

  static Action onLoadData() {
    return const Action(TabWalletAction.loadData);
  }

  static Action onLoadSuccess(List<BannerItem> banners) {
    return Action(TabWalletAction.loadSuccess, payload: banners);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(TabWalletAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(TabWalletAction.showLoading);
  }

  static Action onScanCard({bool isAdd = false}) {
    return Action(TabWalletAction.scanCard, payload: isAdd);
  }

  static Action onDeleteItem(String id) {
    return Action(TabWalletAction.deleteItem, payload: id);
  }

  static Action onUpdateCardInfo(String id, num amount) {
    return Action(TabWalletAction.updateCardInfo,
        payload: {'id': id, 'amount': amount});
  }

  static Action onSetCardAmount(String id, int amount) {
    return Action(TabWalletAction.setCardAmount,
        payload: {'id': id, 'amount': amount});
  }

  static Action onUpdateIndex(int index) {
    return Action(TabWalletAction.updateIndex, payload: index);
  }

  static Action onBannerItemClick(BannerItem item) {
    return Action(TabWalletAction.bannerItemClick, payload: item);
  }

  static Action onReloadMainData() {
    return const Action(TabWalletAction.reloadMainData);
  }
}
