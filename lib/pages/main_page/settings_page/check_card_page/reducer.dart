import 'package:card_coin/bean/health_check_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CheckCardState>? buildReducer() {
  return asReducer(
    <Object, Reducer<CheckCardState>>{
      CheckCardAction.initTask: _onInitTask,
      CheckCardAction.updateShowScan: _onUpdateShowScan,
      CheckCardAction.updateCheckInfoList: _onUpdateCheckInfoList
    },
  );
}

CheckCardState _onInitTask(CheckCardState state, Action action) {
  final CheckCardState newState = state.clone()..checkList = action.payload;
  return newState;
}

CheckCardState _onUpdateShowScan(CheckCardState state, Action action) {
  bool isShowScan = action.payload;
  final CheckCardState newState = state.clone()..showScanTip = action.payload;
  if(isShowScan){
   final list = state.checkList.map((e) => e.copyWith(status: HealthStatus.process)).toList();
   newState.checkList = list;
  }
  return newState;
}

CheckCardState _onUpdateCheckInfoList(CheckCardState state, Action action) {
  final CheckCardState newState = state.clone()..checkList = action.payload;
  return newState;
}

