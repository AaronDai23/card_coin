import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CashOutDetailState>? buildReducer() {
  return asReducer(<Object, Reducer<CashOutDetailState>>{
    CashOutDetailAction.updateLoading: _onUpdateLoading,
    CashOutDetailAction.loadDetailSuccess: _onLoadDetailSuccess,
  });
}

CashOutDetailState _onUpdateLoading(CashOutDetailState state, Action action) {
  final next = state.clone();
  next.isLoading = action.payload as bool;
  return next;
}

CashOutDetailState _onLoadDetailSuccess(
    CashOutDetailState state, Action action) {
  final next = state.clone();
  next.detail = action.payload as CashOutDetailInfo;
  next.isLoading = false;
  return next;
}
