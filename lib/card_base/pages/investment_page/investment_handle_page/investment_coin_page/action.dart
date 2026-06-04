import 'package:card_coin/bean/coin_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum InvestmentCoinAction { selected, textChanged, cancleItem, updateList,update }

class InvestmentCoinActionCreator {
  static Action onSelectedAction(int index) {
    return Action(InvestmentCoinAction.selected, payload: index);
  }

  static Action onUpdateList(List<CoinInfo> list) {
    return Action(InvestmentCoinAction.updateList, payload: list);
  }
}
