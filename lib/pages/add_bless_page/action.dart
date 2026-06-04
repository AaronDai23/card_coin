import 'package:card_coin/card_base/bean/chain_stamp.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AddBlessAction {
  action,
  send,
  updateRemain,
  checkCardNumber,
  updateResults,
  updateLoading,
  selectCard
}

class AddBlessActionCreator {
  static Action onAction() {
    return const Action(AddBlessAction.action);
  }

  static Action onSend() {
    return const Action(AddBlessAction.send);
  }

  static Action onUpdateRemain(int remain) {
    return Action(AddBlessAction.updateRemain, payload: remain);
  }

  static Action onCheckCardNumber(String cardNumber) {
    return Action(AddBlessAction.checkCardNumber, payload: cardNumber);
  }

  static Action updateResults(List<String> results) {
    return Action(AddBlessAction.updateResults, payload: results);
  }

  static Action updateLoading(bool isLoading) {
    return Action(AddBlessAction.updateLoading, payload: isLoading);
  }

  static Action selectCard(ChainStamp card) {
    return Action(AddBlessAction.selectCard, payload: card);
  }
}
