import 'package:card_coin/pigeons/messages.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum TransactionDetailAction { updateList, refresh, loadFailure, loadSuccess }

class TransactionDetailActionCreator {
  static Action onUpdateList(List<TransactionsHistory> list) {
    return Action(TransactionDetailAction.updateList, payload: list);
  }

  static Action onRefresh() {
    return const Action(TransactionDetailAction.refresh);
  }

  static Action onLoadFailure() {
    return const Action(TransactionDetailAction.loadFailure);
  }

  static Action onLoadSuccess(List<TransactionsHistory> list) {
    return Action(TransactionDetailAction.loadSuccess, payload: list);
  }
}
