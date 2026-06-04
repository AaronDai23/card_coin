import 'package:card_coin/card_base/utils/date_util.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    FlowHistoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Flow History')),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      onLoadSuccess: () {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.steps.length,
          itemBuilder: (context, index) {
            final item = state.steps[index];
            final isLast = index == state.steps.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧圆点 + 竖线
                  Column(
                    children: [
                      // 顶部圆点
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // 竖线，自动填充剩余高度
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.black26,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // 右侧内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 时间，与圆点对齐

                        Text(
                          DateUtil.formatTimestamp(item.createTime!),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // 内容卡片
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.transactionResultName != null)
                                Text(item.transactionResultName!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text(
                                  item.smartCardContractFlowItem != null &&
                                          item.smartCardContractFlowItem!
                                                  .name !=
                                              null
                                      ? item.smartCardContractFlowItem!.name!
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(
                                item.smartCardContractFlowItem != null &&
                                        item.smartCardContractFlowItem!
                                                .description !=
                                            null
                                    ? item
                                        .smartCardContractFlowItem!.description!
                                    : "",
                              ),
                              const SizedBox(height: 4),
                              if (item.transaction != null &&
                                  item.transaction!.amount != null)
                                Text(
                                    "Amount: ${item.transaction!.amount!} ${item.transaction!.symbol!}"),
                              if (item.transaction != null &&
                                  item.transaction!.gasInfo != null)
                                Text("Gas: ${item.transaction!.gasInfo!}"),
                              if (item.transaction != null &&
                                  item.transaction!.remark != null)
                                Text("Remark: ${item.transaction!.remark!}"),
                              if (item.transaction != null &&
                                  item.transaction!.toAddress != null)
                                Text(
                                    "To Address: ${item.transaction!.toAddress!}"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
