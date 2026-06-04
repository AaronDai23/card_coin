import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HtmlTextState>? buildReducer() {
  return asReducer(
    <Object, Reducer<HtmlTextState>>{
      HtmlTextAction.action: _onAction,
    },
  );
}

HtmlTextState _onAction(HtmlTextState state, Action action) {
  final HtmlTextState newState = state.clone();
  return newState;
}
