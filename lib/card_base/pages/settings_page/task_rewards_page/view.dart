import 'package:card_coin/card_base/bean/task_detail_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    TaskRewardsState state, Dispatch dispatch, ViewService viewService) {
  // 提供默认值
  final int pendingCount = state.taskSummaryInfo?.pendingCount ?? 0;
  final int receivedCount = state.taskSummaryInfo?.receivedCount ?? 0;
  final int totalCount = state.taskSummaryInfo?.totalCount ?? 0;
  // 提取文本样式
  const TextStyle titleStyle =
      TextStyle(color: Colors.grey, fontSize: 14, height: 1.2);
  const TextStyle subtitleStyle =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  const TextStyle pendingStyle = TextStyle(
    color: Color.fromARGB(255, 211, 145, 145),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Lightning Rewards'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(viewService.context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pending count
                ListTile(
                  title: const Text("Pending count", style: titleStyle),
                  subtitle: Text('$pendingCount', style: pendingStyle),
                ),
                const Divider(), // 添加分割线美化
                // Row for received and total counts
                Row(
                  children: [
                    // Received count
                    Flexible(
                      child: ListTile(
                        title: const Text("Received count", style: titleStyle),
                        subtitle: Text('$receivedCount', style: subtitleStyle),
                      ),
                    ),
                    // Total count
                    Flexible(
                      child: ListTile(
                        title: const Text("Total count", style: titleStyle),
                        subtitle: Text('$totalCount', style: subtitleStyle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            controller: state.refreshController,
            onRefresh: () async {
              // 下拉刷新
              await dispatch(TaskRewardsActionCreator.onGetTaskList());
              state.refreshController.refreshCompleted(); // 刷新完成
            },
            onLoading: () async {
              // 上拉加载
              // await dispatch(TaskRewardsActionCreator.onLoadMoreTasks());
              // state.refreshController.loadComplete(); // 加载完成
            },
            child: state.tasks.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: state.tasks.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10); // 分隔间距
                    },
                    itemBuilder: (context, index) {
                      TaskDetailInfo detailInfo = state.tasks[index];

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300, // 边框颜色
                            width: 1.0, // 边框宽度
                          ),
                          borderRadius: BorderRadius.circular(8.0), // 圆角
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 左侧标题和描述
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detailInfo.amountTypeName,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '${detailInfo.amount} ${detailInfo.unit}',
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateUtil.formatDateMs(
                                            detailInfo.updateTime,
                                            format: DateFormats.full,
                                          ),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // 空白间距
                              const SizedBox(width: 16),
                              // 右侧按钮
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: detailInfo.receiveStatus
                                              .toUpperCase() ==
                                          "PENDING"
                                      ? () {
                                          dispatch(TaskRewardsActionCreator
                                              .onReceiveAction(detailInfo.id));
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: detailInfo.receiveStatus
                                                .toUpperCase() ==
                                            "PENDING"
                                        ? Colors.orange
                                        : Colors.grey,
                                    foregroundColor: Colors.white,
                                  ), // 禁用非 "PENDING" 状态的按钮
                                  child: Text(detailInfo.receiveStatus),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const EmptyListView(),
          ),
        ),
      ]));
}
