import 'package:fish_redux/fish_redux.dart';

enum EditMemberAction { loadData,loadSuccess,loadFailure,showLoading,submitClick,updateCardInfo }

class EditMemberActionCreator {

  static Action onLoadSuccess(bool isBind) {
    return Action(EditMemberAction.loadSuccess,payload: isBind);
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(EditMemberAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(EditMemberAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(EditMemberAction.loadData);
  }

  static Action onSubmitClick() {
    return const Action(EditMemberAction.submitClick);
  }
  static Action onUpdateCardInfo() {
    return const Action(EditMemberAction.updateCardInfo);
  }

}
