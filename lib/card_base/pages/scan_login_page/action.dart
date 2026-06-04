import 'package:fish_redux/fish_redux.dart';

import '../../../cache/bean/user_info_bean.dart';
import '../../bean/banner_bean.dart';
import '../../bean/page_categroy_item.dart';

//TODO replace with your own action
enum ScanLoginAction {
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  buttonItemClick,
  startNFC,
  updateCardId,
  updateUserInfo,
  updateScanning,
  bannerItemClick,
  faceLoginClick
}

class ScanLoginActionCreator {
  static Action onButtonItemClick(PageCategoryItem buttonItem) {
    return Action(ScanLoginAction.buttonItemClick, payload: buttonItem);
  }

  static Action onLoadSuccess(
      List<BannerItem> banners, List<PageCategoryItem> buttons) {
    return Action(ScanLoginAction.loadSuccess,
        payload: {'banners': banners, 'buttons': buttons});
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(ScanLoginAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(ScanLoginAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(ScanLoginAction.loadData);
  }

  static Action onStartNFC() {
    return const Action(ScanLoginAction.startNFC);
  }

  static Action onFaceLoginCclick() {
    return const Action(ScanLoginAction.faceLoginClick);
  }

  static Action onUpdateScanning(bool isScanning) {
    return Action(ScanLoginAction.updateScanning, payload: isScanning);
  }

  static Action onUpdateCardId(String? cardId) {
    return Action(ScanLoginAction.updateCardId, payload: cardId);
  }

  static Action onUpdateUserInfo(UserInfo? userInfo) {
    return Action(ScanLoginAction.updateUserInfo, payload: userInfo);
  }

  static Action onBannerItemClick(BannerItem bannerItem) {
    return Action(ScanLoginAction.bannerItemClick, payload: bannerItem);
  }
}
