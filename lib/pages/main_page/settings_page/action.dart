import 'package:card_coin/card_base/bean/page_categroy_item.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SettingsAction {
  listItemClick,
  createPinCode,
  unlockCard,
  updateSettingList,
  showLoading,
  loadSuccess,
  loadFailure
}

class SettingsActionCreator {
  static Action onListItemClick(PageCategoryItem item) {
    return Action(SettingsAction.listItemClick, payload: item);
  }

  static Action onCreatePinCode() {
    return const Action(SettingsAction.createPinCode);
  }

  static Action onUnlockCard() {
    return const Action(SettingsAction.unlockCard);
  }

  static Action onUpdateSettingList(List<String> settingList) {
    return Action(SettingsAction.updateSettingList, payload: settingList);
  }

  static Action onShowLoading() {
    return const Action(SettingsAction.showLoading);
  }

  static Action onLoadSuccess(List<PageCategoryItem> list) {
    return Action(SettingsAction.loadSuccess, payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(SettingsAction.loadFailure, payload: errorMsg);
  }
}
