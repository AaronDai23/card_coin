
import 'package:fish_redux/fish_redux.dart';

import '../../bean/member_level_bean.dart';

//TODO replace with your own action
enum MemberAction {
  loadSuccess,
  loadFailure,
  showLoading,
  loadData,
  updateIndex,
  showPrivilege
}

class MemberActionCreator {


  static Action onLoadSuccess(MemberLevelInfo memberLevelInfo,CustomerLevelInfo customerInfo) {
    return  Action(MemberAction.loadSuccess,payload: {'memberLevelInfo':memberLevelInfo,'customerInfo':customerInfo});
  }

  static Action onLoadFailure(String errorMsg) {
    return Action(MemberAction.loadFailure,payload: errorMsg);
  }

  static Action onShowLoading() {
    return const Action(MemberAction.showLoading);
  }

  static Action onLoadData() {
    return const Action(MemberAction.loadData);
  }

  static Action onUpdateIndex(int index) {
    return Action(MemberAction.updateIndex,payload: index);
  }

  static Action onShowPrivilegeDetail(String privilegeId) {
    return Action(MemberAction.showPrivilege,payload: privilegeId);
  }
}
