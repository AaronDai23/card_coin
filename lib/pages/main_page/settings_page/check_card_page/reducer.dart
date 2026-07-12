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
  if (isShowScan) {
    final list = state.checkList
        .map((e) => e.copyWith(status: HealthStatus.process))
        .toList();
    newState.checkList = list;
    newState.percent = 0.0; // 新批扫卡开始时重置进度
  }
  return newState;
}

CheckCardState _onUpdateCheckInfoList(CheckCardState state, Action action) {
  final List<HealthCheckInfo> newList = action.payload;

  // 全重置（所有项恢复为 none）：进度清零
  final isReset = newList.every((e) => e.status == HealthStatus.none);
  if (isReset) {
    return state.clone()
      ..checkList = newList
      ..percent = 0.0;
  }

  // 健康度 = 正常完成数 / 总项目数 × 100
  // 有失败项时永远到不了 100%
  final int totalCount = newList.length;
  final int healthCount =
      newList.where((e) => e.status == HealthStatus.health).length;
  final double newPercent =
      totalCount > 0 ? (healthCount / totalCount * 100) : 0.0;

  return state.clone()
    ..checkList = newList
    ..percent = newPercent;
}
