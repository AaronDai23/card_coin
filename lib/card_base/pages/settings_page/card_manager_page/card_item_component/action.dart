
import 'package:fish_redux/fish_redux.dart';

import '../../../../bean/link_bean.dart';

//TODO replace with your own action
enum CardItemAction { itemClick,deleteClick }

class CardItemActionCreator {


  static Action onItemClick(NFCCardItem cardInfo) {
    return Action(CardItemAction.itemClick,payload: cardInfo);
  }
  static Action onDeleteClick(NFCCardItem cardInfo) {
    return Action(CardItemAction.deleteClick,payload: cardInfo);
  }
}
