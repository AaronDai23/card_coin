import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AddCardAction { submitClick,loadSuccess,loadFailure,showLoading,loadData }

class AddCardActionCreator {
  static Action onSubmitClick() {
    return const Action(AddCardAction.submitClick);
  }

  static Action onLoadSuccess(bool isBind) {
    return Action(AddCardAction.loadSuccess,payload: isBind);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(AddCardAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(AddCardAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(AddCardAction.loadData);
  }
}
