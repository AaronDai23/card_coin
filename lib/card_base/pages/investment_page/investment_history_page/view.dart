import 'package:card_coin/card_base/bean/investment_history_info.dart';
import 'package:card_coin/card_base/utils/date_util.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvestmentHistoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          title: const Text('Transaction History')),
      body: BasePageLoadingView(
          onReload: () {},
          buildBody: (isLoadSuccess) {
            if (isLoadSuccess) {
              if (state.list.isNotEmpty) {
                return SmartRefresher(
                    controller: state.refreshController,
                    onRefresh: () {
                      // Future.delayed(const Duration(seconds: 1)).then((value) =>
                      //     state.refreshController.refreshCompleted());
                      dispatch(InvestmentHistoryActionCreator.onLoadData(
                          isLoadMore: true));
                    },
                    onLoading: () {
                      // dispatch(
                      //     InviteListActionCreator.onLoadData(isLoadMore: true));
                    },
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        InvestmentHistoryInfo info = state.list[index];
                        print("InvestmentHistoryInfo_info: ${info.status}");
                        return Card(
                          color: Colors.grey[200], // Light blue background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Amount and BTC amount
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        info.remarks ?? "",
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: info.status!.toUpperCase() ==
                                                'COMPLETED'.toUpperCase()
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        info.statusName ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Date and status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pay ${info.assetFrom} ${info.assetFromAmount}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Text(
                                      DateUtil.formatTimestamp(
                                          info.createTime!),
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: state.list.length,
                    ));
              } else {
                return const EmptyListView();
              }
            } else {
              return const SizedBox();
            }
          },
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg)
      //  Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ,
      // ),
      );
}
