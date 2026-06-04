
import 'package:fish_redux/fish_redux.dart';

import '../../../bean/link_bean.dart';

//TODO replace with your own action
enum AddDetailAction {
  buttonClick,
  updateLink,
  addLink,
  deleteLink,
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
}

class AddDetailActionCreator {

  static Action onLoadSuccess(LinkTypeDetail typeDetail) {
    return  Action(AddDetailAction.loadSuccess,payload: typeDetail);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(AddDetailAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(AddDetailAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(AddDetailAction.loadData);
  }

  static Action onButtonClick() {
    return const Action(AddDetailAction.buttonClick);
  }

  static Action onUpdateLink() {
    return const Action(AddDetailAction.updateLink);
  }

  static Action onAddLink() {
    return const Action(AddDetailAction.addLink);
  }

  static Action onDeleteLink() {
    return const Action(AddDetailAction.deleteLink);
  }


}
