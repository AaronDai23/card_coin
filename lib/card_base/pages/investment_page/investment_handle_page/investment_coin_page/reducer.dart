import 'package:card_coin/bean/coin_info.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InvestmentCoinState>? buildReducer() {
  return asReducer(
    <Object, Reducer<InvestmentCoinState>>{
      InvestmentCoinAction.updateList: _onUpdateList,
    },
  );
}

InvestmentCoinState _onUpdateList(InvestmentCoinState state, Action action) {
  List<CoinInfo> list = action.payload;
  final InvestmentCoinState newState = state.clone()..fiats = list;
  return newState;
}
