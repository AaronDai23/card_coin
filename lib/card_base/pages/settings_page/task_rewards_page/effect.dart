import 'package:card_coin/card_base/bean/task_detail_info.dart';
import 'package:card_coin/card_base/bean/task_summary_info.dart';
import 'package:card_coin/http/address.dart';
import 'package:card_coin/http/http_manager.dart';
import 'package:card_coin/utils/scan_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'action.dart';
import 'state.dart';

Effect<TaskRewardsState>? buildEffect() {
  return combineEffects(<Object, Effect<TaskRewardsState>>{
    Lifecycle.initState: _onInit,
    TaskRewardsAction.action: _onAction,
    TaskRewardsAction.getSummaryInfo: _onSummaryInfo,
    TaskRewardsAction.getTaskList: _onTaskList,
    TaskRewardsAction.receive: _onReceive,
  });
}

Future<void> _onInit(Action action, Context<TaskRewardsState> ctx) async {
  ctx.dispatch(TaskRewardsActionCreator.onGetSummaryInfo());
  ctx.dispatch(TaskRewardsActionCreator.onGetTaskList());
}

void _onAction(Action action, Context<TaskRewardsState> ctx) {}

Future<void> _onSummaryInfo(
    Action action, Context<TaskRewardsState> ctx) async {
  var result0 =
      await HttpManager.getInstance().get(NetworkAddress.getLightningBalance);
  // result0.data = {
  //   "pendingCount": 1,
  //   "receivedCount": 1,
  //   "todayPendingCount": 0,
  //   "todayReceivedCount": 0,
  //   "totalCount": 3,
  //   "yesterdayPendingCount": 0,
  //   "yesterdayReceivedCount": 0
  // };
  // result0.isSuccess = true;
  if (result0.isSuccess) {
    print("_onSummaryInfo:--sucesss");
    if (result0.data != null) {
      var taskSummaryInfo = TaskSummaryInfo.fromJson(result0.data);
      print("_onSummaryInfo:--sucesss11");
      ctx.dispatch(
          TaskRewardsActionCreator.onupdateSummaryInfo(taskSummaryInfo));
    }
  }
}

Future<void> _onTaskList(Action action, Context<TaskRewardsState> ctx) async {
  var result0 =
      await HttpManager.getInstance().get(NetworkAddress.getLightningPage);

  // result0.data = {
  //   "total": 1,
  //   "rows": [
  //     {
  //       "amount": 0.25,
  //       "amountDirection": "POSITIVE",
  //       "amountType": "TASK_ITEM_AWARD",
  //       "amountTypeFullName": "Task Item Award",
  //       "amountTypeName": "Task Item Award",
  //       "createBy": "",
  //       "createTime": 1731328726000,
  //       "customerId": "5951da509beb4b4f922f31cf4a6db001",
  //       "customerName": "",
  //       "id": "ceca909bb1ad47bd9d926adb6583c251",
  //       "orgId": "df59e3b2c3424431bc6f4053a86632c0",
  //       "receiveBy": "112233AA",
  //       "receiveStatus": "RECEIVED",
  //       "receiveStatusName": "received",
  //       "refId": "4f8300c26ad847ef81999d94df25bc78",
  //       "status": "CONFIRMED",
  //       "statusName": "Confirmed",
  //       "unit": "USDT",
  //       "updateBy": "",
  //       "updateTime": 1731328726000
  //     }
  //   ]
  // };
  // result0.isSuccess = true;
  if (result0.isSuccess) {
    print("_onTaskList:--sucesss");
    if (result0.data != null) {
      int total = result0.data['total'];
      if (total == 0) {
        ctx.state.refreshController.refreshCompleted();
        ctx.dispatch(TaskRewardsActionCreator.onLoadSuccess([]));
        return;
      }
      List list = result0.data['rows'];
      var taskList = list.map((e) => TaskDetailInfo.fromJson(e)).toList();
      ctx.state.refreshController.loadNoData();
      ctx.dispatch(TaskRewardsActionCreator.onLoadSuccess(taskList));
    } else {
      print("_onTaskList:--fail");
      ctx.state.refreshController.refreshFailed();
      ctx.dispatch(TaskRewardsActionCreator.onLoadFailure(result0.message));
    }
  }
}

Future<void> _onReceive(Action action, Context<TaskRewardsState> ctx) async {
  final scanResponse = await ScanUtil.chipScanOnly();
  if (scanResponse.isSuccess) {
    String uuid = scanResponse.data;
    var result0 = await HttpManager.getInstance().post(
        NetworkAddress.getLightningReceive, null,
        data: {'id': action.payload, 'uid': uuid});
    if (result0.isSuccess) {
      showToast("Receive successful!");
      TaskDetailInfo taskDetailInfo =
          ctx.state.tasks.firstWhere((element) => element.id == action.payload);
      taskDetailInfo.receiveStatus = 'RECEIVED';

      ctx.dispatch(TaskRewardsActionCreator.onGetSummaryInfo());
      ctx.dispatch(TaskRewardsActionCreator.onGetTaskList());
    } else {}
  } else {
    if (scanResponse.message != null &&
        scanResponse.message!.isNotEmpty &&
        scanResponse.message!.length < 100) {
      showToast(scanResponse.message!);
    }
    // if (scanResponse.message! == 'Session invalidated by user') {
    //   return;
    // }
    // showToast(scanResponse.message ?? '');
  }
}
