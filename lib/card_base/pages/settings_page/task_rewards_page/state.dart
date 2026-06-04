import 'dart:ui';

import 'package:card_coin/card_base/bean/task_detail_info.dart';
import 'package:card_coin/card_base/bean/task_summary_info.dart';
import 'package:card_coin/global_store/states/app_language_resource.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskRewardsState implements LoadPageState<TaskRewardsState> {
  @override
  TaskRewardsState clone() {
    return TaskRewardsState()
      ..languageLocale = languageLocale
      ..languageResource = languageResource
      ..taskSummaryInfo = taskSummaryInfo
      ..refreshController = refreshController
      ..tasks = tasks
      ..errorMsg = errorMsg
      ..loadStatus = loadStatus;
  }

  @override
  Locale? languageLocale;

  @override
  String errorMsg = '';

  @override
  AppLanguageResource? languageResource;

  TaskSummaryInfo? taskSummaryInfo;

  RefreshController refreshController = RefreshController();
  List<TaskDetailInfo> tasks = [];

  @override
  LoadType loadStatus = LoadType.loading;
}

TaskRewardsState initState(Map<String, dynamic>? args) {
  return TaskRewardsState();
}
