import 'package:card_coin/cache/bean/user_info_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import '../../bean/page_categroy_item.dart';

//TODO replace with your own action
enum SettingsAction {
  loadSuccess,
  loadFailure,
  loadData,
  showLoading,
  loginOutClick,
  itemClick,
  cancelAccount,
  writeCard,
  refreshUserInfo,
  editNameClick,
  editAvatarClick,
  updateCurrentIndexLan,
  selectLanguage,
  networkCheck
}

class SettingsActionCreator {
  static Action onLoadSuccess(List<PageCategoryItem> list) {
    return Action(SettingsAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(SettingsAction.loadFailure, payload: errorMsg);
  }

  static Action onEditNameClick() {
    return const Action(SettingsAction.editNameClick);
  }

  static Action onEditAvatarClick() {
    return const Action(SettingsAction.editAvatarClick);
  }

  static Action onLoadData() {
    return const Action(SettingsAction.loadData);
  }

  static Action onShowLoading() {
    return const Action(SettingsAction.showLoading);
  }

  static Action onLoginOutClick() {
    return const Action(SettingsAction.loginOutClick);
  }

  static Action onItemClick(PageCategoryItem categoryItem) {
    return Action(SettingsAction.itemClick, payload: categoryItem);
  }

  static Action onCancelAccount() {
    return const Action(SettingsAction.cancelAccount);
  }

  static Action onWriteCard() {
    return const Action(SettingsAction.writeCard);
  }

  static Action onRefreshUserInfo(UserInfo userInfo) {
    return Action(SettingsAction.refreshUserInfo, payload: userInfo);
  }

  static Action onUpdateCurrentIndexLan(int index) {
    return Action(SettingsAction.updateCurrentIndexLan, payload: index);
  }

  static Action onSelectLanguage() {
    return const Action(SettingsAction.selectLanguage);
  }

  static Action onNetworkCheck() {
    return const Action(SettingsAction.networkCheck);
  }
}
