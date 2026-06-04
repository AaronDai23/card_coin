import 'package:fish_redux/fish_redux.dart';
import '../adapter/state.dart';

Reducer<CardGroupItemState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CardGroupItemState>>{
      // MemberItemAction.action: _onAction,
    },
  );
}
