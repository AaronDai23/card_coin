import 'package:card_coin/bean/update_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../../cache/bean/user_info_bean.dart';
import '../../bean/more_menu_info.dart';
import '../../bean/page_categroy_item.dart';

//TODO replace with your own action
enum MainAction {
  action,
  loadSuccess,
  loadFailure,
  reload,
  showLoading,
  headerPhotoClick,
  updateUserInfo,
  startNFC,
  addClick,
  updateCardId,
  jump,
  applyJump,
  showMenu,
  updateCategoryList,
  menuItemClick,
  checkUpdate,
  loadUnreadCount,
  updateUnReadCount,
  upgrade,
  upgradeApp,
  startAppsFlyer,
  notificationback
}

class MainActionCreator {
  static Action onAction() {
    return const Action(MainAction.action);
  }

  static Action onLoadSuccess(List<PageCategoryItem> list) {
    return Action(MainAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MainAction.loadFailure, payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MainAction.showLoading);
  }

  static Action onReload() {
    return const Action(MainAction.reload);
  }

  static Action onHeaderPhotoClick() {
    return const Action(MainAction.headerPhotoClick);
  }

  static Action onUpdateUserInfo(UserInfo? userInfo) {
    return Action(MainAction.updateUserInfo, payload: userInfo);
  }

  static Action onStartNFC() {
    return const Action(MainAction.startNFC);
  }

  static Action onAddClick() {
    return const Action(MainAction.addClick);
  }

  static Action onUpdateCardId(String? cardId) {
    return Action(MainAction.updateCardId, payload: cardId);
  }

  static Action onJump(int index) {
    return Action(MainAction.jump, payload: index);
  }

  static Action onApplyJump(int index) {
    return Action(MainAction.applyJump, payload: index);
  }

  static Action onShowMenu() {
    return const Action(MainAction.showMenu);
  }

  static Action onUpdateCategoryList(MoreMenuInfo menuInfo) {
    return Action(MainAction.updateCategoryList, payload: menuInfo);
  }

  static Action onMenuItemClick(MoreMenuItem menuItem) {
    return Action(MainAction.menuItemClick, payload: menuItem);
  }

  static Action onCheckUpdate() {
    return const Action(MainAction.checkUpdate);
  }

  static Action onLoadUnreadCount() {
    return const Action(MainAction.loadUnreadCount);
  }

  static Action onUpdateUnReadCount(int unReadCount) {
    return Action(MainAction.updateUnReadCount, payload: unReadCount);
  }

  static Action onUpGrade() {
    return const Action(MainAction.upgrade);
  }

  static Action onUpgradeApp(UpdateInfo updateInfo) {
    return Action(MainAction.upgradeApp, payload: updateInfo);
  }

  static Action onStartAppsFlyer() {
    return const Action(MainAction.startAppsFlyer);
  }

  static Action onNotificationBackClick() {
    return const Action(MainAction.notificationback);
  }
}
