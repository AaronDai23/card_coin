import 'package:fish_redux/fish_redux.dart';

import '../../../bean/diagnostic_bean.dart';

//TODO replace with your own action
enum NetworkCheckAction { action,addResult,updateResult }

class NetworkCheckActionCreator {
  static Action onAction() {
    return const Action(NetworkCheckAction.action);
  }
  static Action onAddResult(DiagnosticItemResult result) {
    return Action(NetworkCheckAction.addResult, payload: result);
  }

  static Action onUpdateResult(int index,DiagnosticItemResult result) {
    return Action(NetworkCheckAction.updateResult, payload: {'index':index,'item':result});
  }
}
