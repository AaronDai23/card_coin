import 'package:card_coin/card_base/bean/activate_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PackageActivateAction { action,loadData,loadSuccess,loadFailure,showLoading,checkClick,updateSelectedList, activateClick }

class PackageActivateActionCreator {

  static Action onAction() {
    return const Action(PackageActivateAction.action);
  }

  static Action onLoadData() {
    return const Action(PackageActivateAction.loadData);
  }

  static Action onLoadSuccess(ActivatePackageSummary summaryInfo,List<CardPackage> list) {
    return Action(PackageActivateAction.loadSuccess,payload: {'summaryInfo':summaryInfo,'packageList':list});
  }
  static Action onLoadFailure(String errorMsg) {
    return Action(PackageActivateAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(PackageActivateAction.showLoading);
  }

  static Action onCheckClick(int index) {
    return Action(PackageActivateAction.checkClick,payload: index);
  }

  static Action onUpdateSelectedList(List<int> list) {
    return Action(PackageActivateAction.updateSelectedList,payload: list);
  }

  static Action onActivateClick() {
    return const Action(PackageActivateAction.activateClick);
  }

}
