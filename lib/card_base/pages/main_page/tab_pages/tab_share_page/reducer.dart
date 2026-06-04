
import 'package:fish_redux/fish_redux.dart';

import '../../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Reducer<TabShareState>? buildReducer() {
  return asReducer(
    <Object, Reducer<TabShareState>>{
      // TabShareAction.action: _onAction,
      TabShareAction.loadSuccess: _onLoadSuccess,
      TabShareAction.loadFailure: _onLoadFailure,
      TabShareAction.showLoading: _onShowLoading,
    },
  );
}

TabShareState _onShowLoading(TabShareState state, Action action) {
  final TabShareState newState = state.clone()..loadStatus = LoadType.loading;
  return newState;
}

TabShareState _onLoadSuccess(TabShareState state, Action action) {
  final TabShareState newState = state.clone()
    ..loadStatus = LoadType.loadSuccess
    ..linkDomain = action.payload
  ;
  return newState;
}

TabShareState _onLoadFailure(TabShareState state, Action action) {
  final TabShareState newState = state.clone()
    ..loadStatus = LoadType.loadFailure
    ..errorMsg = action.payload;
  return newState;
}
