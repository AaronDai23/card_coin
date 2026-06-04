import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<CardItemState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CardItemState>>{
      // CardItemAction.action: _onAction,
    },
  );
}
