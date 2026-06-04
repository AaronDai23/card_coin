import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
  InvestmentProcessState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  return WillPopScope(
      onWillPop: () async {
        dispatch(InvestmentProcessActionCreator.onBackClick());
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Investment Process"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: Theme.of(viewService.context)
                    .extension<GradientTheme>()!
                    .primaryGradient,
              ),
            ),
          ),
          body: PageDataLoadingView(
            loadStatus: state.loadStatus,
            errorMsg: state.errorMsg,
            onReload: () {
              // dispatch(GroupCardActionCreator.onShowLoading());
              // dispatch(GroupCardActionCreator.onLoadData());
            },
            onLoadSuccess: () {
              return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Please finish all steps,current step is:${state.steps[state.progressSetp].smartCardContractFlowItem!.name!}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 时间轴内容居中 + 限宽
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 320,
                          child: _buildStepTimeline(
                              dispatch, state, viewService.context),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Divider(),
                      const SizedBox(height: 8),

                      if (state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!.amount !=
                              null &&
                          state.steps[state.progressSetp].transaction!.amount!
                              .isNotEmpty &&
                          state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!.symbol !=
                              null &&
                          state.steps[state.progressSetp].transaction!.symbol!
                              .isNotEmpty)
                        _buildLabelValue(
                          "Amount",
                          "${state.steps[state.progressSetp].transaction!.amount!} ${state.steps[state.progressSetp].transaction!.symbol!}",
                        ),
                      if (state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!
                                  .gasInfo !=
                              null &&
                          state.steps[state.progressSetp].transaction!.gasInfo!
                              .isNotEmpty)
                        _buildLabelValue(
                          "Gas",
                          state.steps[state.progressSetp].transaction!.gasInfo!,
                        ),
                      if (state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!.remark !=
                              null &&
                          state.steps[state.progressSetp].transaction!.remark!
                              .isNotEmpty)
                        _buildLabelValue(
                          "Remark",
                          state.steps[state.progressSetp].transaction!.remark!,
                        ),
                      if (state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!
                                  .rowTransactionHash !=
                              null &&
                          state.steps[state.progressSetp].transaction!
                              .rowTransactionHash!.isNotEmpty)
                        _buildLabelValue(
                          "RowTransactionHash",
                          state.steps[state.progressSetp].transaction!
                              .rowTransactionHash!,
                        ),

                      if (state.steps[state.progressSetp].transaction != null &&
                          state.steps[state.progressSetp].transaction!
                                  .toAddress !=
                              null &&
                          state.steps[state.progressSetp].transaction!
                              .toAddress!.isNotEmpty)
                        _buildLabelValue(
                          "To Address",
                          state.steps[state.progressSetp].transaction!
                              .toAddress!,
                        ),

                      const SizedBox(height: 50), // 给底部按钮预留空间
                      state.isShowActiveCard == true
                          ? Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: 48,
                                  width: 320,
                                  child: ElevatedButton(
                                      onPressed: state.progressSetp >= 0 &&
                                              state.steps[state.progressSetp]
                                                      .transactionResult !=
                                                  "PROCESSING" &&
                                              state.steps[state.progressSetp]
                                                      .transactionResult !=
                                                  "SUCCESS"
                                          ? () {
                                              if (state.fromeIndex == 0) {
                                                dispatch(
                                                    InvestmentProcessActionCreator
                                                        .onSignDCA());
                                              } else {
                                                if (state.progressSetp == 0) {
                                                  dispatch(
                                                      InvestmentProcessActionCreator
                                                          .onScanAction());
                                                } else {
                                                  dispatch(
                                                      InvestmentProcessActionCreator
                                                          .onSignDCA());
                                                }
                                              }
                                            }
                                          : null,
                                      style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty
                                              .resolveWith<Color>((states) {
                                            if (states.contains(
                                                WidgetState.disabled)) {
                                              return Colors
                                                  .grey.shade300; // 禁用时
                                            }
                                            return Colors.black; // 正常
                                          }),
                                          foregroundColor: WidgetStateProperty
                                              .resolveWith<Color>((states) {
                                            if (states.contains(
                                                WidgetState.disabled)) {
                                              return Colors
                                                  .grey.shade300; // 禁用时
                                            }
                                            return Colors.black; // 正常
                                          }),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      40), // 这里设置圆角半径
                                            ),
                                          )),
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.0),
                                        child: Text(
                                          "continue",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )))),
                            )
                          : const SizedBox()
                    ],
                  ));
            },
          )));
}

Widget _buildStepTimeline(
  Dispatch dispatch,
  InvestmentProcessState state,
  BuildContext ctx,
) {
  final steps = state.steps;
  return Column(
    children: List.generate(steps.length, (index) {
      final step = steps[index];

      final isLast = index == steps.length - 1;
      final isCurrent = step.transactionResult == 'SUCCESS' ||
          step.transactionResult == 'USED';
      final isFail = step.transactionResult == 'FAILED' ||
          step.transactionResult == 'EXPIRED';

      final isProcessing = step.transactionResult == 'PROCESSING';

      return IntrinsicHeight(
        // 让 Row 根据最高内容自适应高度
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // ✨ 垂直方向按中线对齐
          children: [
            // 左边圆点 + 竖线
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25, // 缩小5
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? Colors.green
                        : isFail
                            ? Colors.red
                            : isProcessing
                                ? Colors.white
                                : Colors.grey,
                    border: Border.all(
                      color: isCurrent
                          ? Colors.green
                          : isFail
                              ? Colors.red
                              : isProcessing
                                  ? Colors.white
                                  : Colors.grey,
                    ),
                  ),
                  child: isCurrent
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : isFail
                          ? const Icon(Icons.close,
                              size: 12, color: Colors.white)
                          : isProcessing
                              ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),

            const SizedBox(width: 30),

            // 右边文本
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min, // ✨ 让高度包裹内容
                mainAxisAlignment: MainAxisAlignment.center, // ✨ 垂直居中于点
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.smartCardContractFlowItem!.name!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (step.smartCardContractFlowItem!.description != null &&
                      step.smartCardContractFlowItem!.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        step.smartCardContractFlowItem!.description!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget _buildLabelValue(String label, String value,
    {bool isMonospace = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(
          child: SelectableText(
            value,
            style: TextStyle(
              fontFamily: isMonospace ? 'Courier' : null,
            ),
          ),
        ),
      ],
    ),
  );
}
