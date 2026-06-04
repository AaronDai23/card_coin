import 'package:card_coin/card_base/bean/diagnostic_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NetworkCheckState>? buildReducer() {
  return asReducer(
    <Object, Reducer<NetworkCheckState>>{
      NetworkCheckAction.action: _onAction,
      NetworkCheckAction.addResult: _onAddResult,
      NetworkCheckAction.updateResult: _onUpdateResult,
    },
  );
}

NetworkCheckState _onAction(NetworkCheckState state, Action action) {
  final NetworkCheckState newState = state.clone();
  return newState;
}

NetworkCheckState _onAddResult(
    NetworkCheckState state, Action action) {
  var list = state.resultList.toList();
  list.add(action.payload);
  final NetworkCheckState newState = state.clone()..resultList = list;
  return newState;
}


NetworkCheckState _onUpdateResult(
    NetworkCheckState state, Action action) {
  int index = action.payload['index'];
  DiagnosticItemResult result = action.payload['item'];

  var list = state.resultList.toList();
  list[index] = result;

  final NetworkCheckState newState = state.clone()..resultList = list;
  return newState;
}
