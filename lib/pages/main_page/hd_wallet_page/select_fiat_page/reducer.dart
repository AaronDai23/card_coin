import 'package:card_coin/bean/fiat_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SelectFiatState>? buildReducer() {
  return asReducer(
    <Object, Reducer<SelectFiatState>>{
      SelectFiatAction.textChanged: _onTextChangedAction,
      SelectFiatAction.updateList: _onUpdateList,
    },
  );
}

SelectFiatState _onTextChangedAction(SelectFiatState state, Action action) {
  final SelectFiatState newState = state.clone();
  return newState;
}

SelectFiatState _onUpdateList(SelectFiatState state, Action action) {
  List<FiatInfo> list = action.payload;

  final SelectFiatState newState = state.clone()..fiats = list;
  return newState;
}
