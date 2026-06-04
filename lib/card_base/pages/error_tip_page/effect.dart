import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ErrorTipState>? buildEffect() {
  return combineEffects(<Object, Effect<ErrorTipState>>{
    ErrorTipAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ErrorTipState> ctx) {}
