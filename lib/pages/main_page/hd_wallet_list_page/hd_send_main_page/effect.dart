import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<HdSendMainState>? buildEffect() {
  return combineEffects(<Object, Effect<HdSendMainState>>{
    HdSendMainAction.action: _onAction,
  });
}

void _onAction(Action action, Context<HdSendMainState> ctx) {}
