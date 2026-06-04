import 'package:card_coin/card_base/bean/crypto_setting_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AssetSettingsAction { itemClick,sectionClick,loadData,loadSuccess,loadFailure,showLoading,updateList,saveClick }

class AssetSettingsActionCreator {

  static Action onSaveClock() {
    return const Action(AssetSettingsAction.saveClick);
  }

  static Action onSectionClick(int index,bool value) {
    return Action(AssetSettingsAction.sectionClick,payload: {'index':index,'value':value});
  }

  static Action onItemClick(int sectionIndex,int index,bool value) {
    return Action(AssetSettingsAction.itemClick,payload: {'sectionIndex':sectionIndex,'index':index,'value':value});
  }

  static Action onLoadData() {
    return const Action(AssetSettingsAction.loadData);
  }

  static Action onLoadSuccess(List<CryptoSettingInfo> list) {
    return Action(AssetSettingsAction.loadSuccess,payload: list);
  }

  static Action onUpdateList(List<CryptoSettingInfo> list) {
    return Action(AssetSettingsAction.updateList,payload: list);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(AssetSettingsAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(AssetSettingsAction.showLoading);
  }
}
