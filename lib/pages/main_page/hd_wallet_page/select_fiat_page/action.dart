import 'package:card_coin/bean/fiat_bean.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SelectFiatAction { selected, textChanged, cancleItem, updateList }

class SelectFiatActionCreator {
  static Action onTextChanged(String text) {
    return Action(SelectFiatAction.textChanged, payload: text);
  }

  static Action onSelectedAction(FiatInfo fiatInfo) {
    return Action(SelectFiatAction.selected, payload: fiatInfo);
  }

  static Action onUpdateList(List<FiatInfo> list) {
    return Action(SelectFiatAction.updateList, payload: list);
  }
}
