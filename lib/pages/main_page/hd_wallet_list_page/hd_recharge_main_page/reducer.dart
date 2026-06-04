import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HdRechargeMainState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HdRechargeMainState>>{
      HdRechargeMainAction.action: _onAction,
      HdRechargeMainAction.jump: _onJump,
    },
  );
}

HdRechargeMainState _onAction(HdRechargeMainState state, Action action) {
  final HdRechargeMainState newState = state.clone();
  return newState;
}

HdRechargeMainState _onJump(HdRechargeMainState state, Action action) {
  final HdRechargeMainState newState = state.clone()
    ..currentIndex = action.payload;
  return newState;
}
