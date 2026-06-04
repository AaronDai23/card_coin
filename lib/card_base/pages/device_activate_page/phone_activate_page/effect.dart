import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<PhoneActivateState>? buildEffect() {
  return combineEffects(<Object, Effect<PhoneActivateState>>{
    PhoneActivateAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PhoneActivateState> ctx) {
}
