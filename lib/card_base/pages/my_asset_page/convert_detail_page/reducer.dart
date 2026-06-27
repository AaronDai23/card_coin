import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ConvertDetailState>? buildReducer() {
  return asReducer(<Object, Reducer<ConvertDetailState>>{
    ConvertDetailAction.updateLoading: _onUpdateLoading,
    ConvertDetailAction.loadDetailSuccess: _onLoadDetailSuccess,
  });
}

ConvertDetailState _onUpdateLoading(ConvertDetailState state, Action action) {
  final next = state.clone();
  next.isLoading = action.payload as bool;
  return next;
}

ConvertDetailState _onLoadDetailSuccess(
    ConvertDetailState state, Action action) {
  final next = state.clone();
  next.detail = action.payload as ConvertDetailInfo;
  next.isLoading = false;
  return next;
}
