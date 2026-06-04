import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<HtmlTextState>? buildEffect() {
  return combineEffects(<Object, Effect<HtmlTextState>>{
    HtmlTextAction.action: _onAction,
  });
}

void _onAction(Action action, Context<HtmlTextState> ctx) {
}
