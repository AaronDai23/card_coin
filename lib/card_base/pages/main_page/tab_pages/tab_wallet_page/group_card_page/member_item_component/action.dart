
import 'package:fish_redux/fish_redux.dart';

import '../../../../../../bean/card_member_bean.dart';

//TODO replace with your own action
enum MemberItemAction { memberItemClick,editClick }

class MemberItemActionCreator {

  static Action onMemberItemClick(MemberCardItem cardItem) {
    return Action(MemberItemAction.memberItemClick,payload: cardItem);
  }

  static Action onEditClick(MemberCardItem cardItem) {
    return Action(MemberItemAction.editClick,payload: cardItem);
  }
}
