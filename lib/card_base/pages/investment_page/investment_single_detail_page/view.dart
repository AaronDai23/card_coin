import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(InvestmentSingleDetailState state, Dispatch dispatch,
    ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text("Detail"),
        actions: [
          IconButton(
              onPressed: () {
                dispatch(InvestmentSingleDetailActionCreator.onPushWallet());
              },
              icon: const Icon(Icons.wallet))
        ],
      ),
      body: BasePageLoadingView(
          onReload: () {},
          buildBody: (isLoadSuccess) {
            if (isLoadSuccess) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部状态
                    Text(
                      state.investmentSingleInfo?.statusName ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // 金额显示
                    Text(
                      "${state.investmentSingleInfo!.investmentBalance?.totalUsdDisplayAmount} USD",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),

                    // 信息卡片
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                              "${state.investmentSingleInfo!.investmentBalance?.assetToName}",
                              "${state.investmentSingleInfo!.investmentBalance?.assetToBalance} ${state.investmentSingleInfo!.investmentBalance?.assetToCode}\n ${state.investmentSingleInfo!.investmentBalance?.assetToUsdDisplayAmount} USD"),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                              "${state.investmentSingleInfo!.investmentBalance?.assetFromName}",
                              "${state.investmentSingleInfo!.investmentBalance?.assetFromBalance} ${state.investmentSingleInfo!.investmentBalance?.assetFromCode}\n~ ${state.investmentSingleInfo!.investmentBalance?.assetFromUsdDisplayAmount} USD"),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                              (state.investmentSingleInfo != null &&
                                      state.investmentSingleInfo!.status ==
                                          'TERMINATED')
                                  ? 'Resume'
                                  : ' Stop', () {
                            dispatch(
                                InvestmentSingleDetailActionCreator.onStop());
                          }),
                          _buildActionButton("Flow History", () {
                            dispatch(
                                InvestmentSingleDetailActionCreator.onStop());
                          })
                        ],
                      ),
                    ),

                    // 底部按钮
                    // Center(
                    //   child: OutlinedButton(
                    //     style: OutlinedButton.styleFrom(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       side: const BorderSide(color: Colors.black),
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 32, vertical: 12),
                    //     ),
                    //     onPressed: () {
                    //       // 停止按钮逻辑
                    //       dispatch(
                    //           InvestmentSingleDetailActionCreator.onStop());
                    //     },
                    //     child: const Text(
                    //       "Stop",
                    //       style: TextStyle(fontSize: 16, color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else {
              return const EmptyListView();
            }
          },
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg));
}

Widget _buildInfoRow(String left, String right) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(left, style: const TextStyle(fontSize: 16)),
      const Spacer(),
      Text(
        right,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.right,
      ),
    ],
  );
}

Widget _buildActionButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
