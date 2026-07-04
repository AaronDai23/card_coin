import 'package:card_coin/card_base/bean/investment_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvestmentState state, Dispatch dispatch, ViewService viewService) {
  return WillPopScope(
      onWillPop: () async {
        dispatch(InvestmentActionCreator.onActivitedNofi());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          title: const Text("Investment"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              dispatch(InvestmentActionCreator.onActivitedNofi());
            },
          ),
          // actions: [
          //   PopupMenuButton<String>(
          //     onSelected: (String value) {
          //       if (value == '1') {
          //         dispatch(InvestmentActionCreator.onPushWalletPage(
          //             state.uid ?? ''));
          //       } else {
          //         dispatch(InvestmentActionCreator.onPusBalancePage(
          //             state.uid ?? ''));
          //       }
          //     },
          //     itemBuilder: (BuildContext context) => [
          //       PopupMenuItem(value: "1", child: Text("Wallet")),
          //       PopupMenuItem(value: "2", child: Text("Balance")),
          //     ],
          //   ),
          // ],
        ),
        body: BasePageLoadingView(
            onReload: () {
              dispatch(InvestmentActionCreator.onLoadData());
            },
            buildBody: (isLoadSuccess) {
              if (isLoadSuccess) {
                if (state.list.isNotEmpty) {
                  return SmartRefresher(
                      controller: state.refreshController,
                      onRefresh: () {
                        dispatch(InvestmentActionCreator.onLoadData(
                            isLoadMore: true));
                      },
                      onLoading: () {
                        //   dispatch(InvestmentActionCreator.onLoadData(
                        //    isLoadMore: true));
                      },
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          InvestmentInfo invest = state.list[index];
                          String title = "";
                          if (invest.intervalType == 'MINUTES') {
                            title =
                                "every ${invest.intervalExtend1} minutes buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          } else if (invest.intervalType == 'HOURS') {
                            title =
                                "every ${invest.intervalExtend1} hours buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          } else if (invest.intervalType == 'DAYS') {
                            title =
                                "every day time: ${invest.intervalExtend1}  buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          } else if (invest.intervalType == 'WEEKS') {
                            title =
                                "every week: weekday ${invest.intervalExtend1} time: ${invest.intervalExtend2}  buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          } else if (invest.intervalType == 'MONTH') {
                            title =
                                "every month day: ${invest.intervalExtend1}  time: ${invest.intervalExtend2}  buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          } else if (invest.intervalType == 'YEAR') {
                            title =
                                "every year month: ${invest.intervalExtend1} time: ${invest.intervalExtend2}  buy \$${invest.assetFromAmount} ${invest.assetTo}";
                          }

                          return GestureDetector(
                              onTap: () {
                                dispatch(InvestmentActionCreator.onDetailData(
                                    invest));
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Card(
                                    elevation: 5, // 添加阴影
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16), // 圆角
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 标题
                                          Text(
                                            '${invest.name}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          invest.contractBalance != null
                                              ? // 资产信息
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                      Text(
                                                        'Contract balance ${invest.contractBalance!.balance} ${invest.contractBalance!.symbol}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ])
                                              : const SizedBox(),
                                          // 日期和时间
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  invest.intervalDescription ==
                                                          null
                                                      ? title
                                                      : invest
                                                          .intervalDescription!,
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis, // 如果文本过长，显示省略号
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange, // 按钮背景色
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: Text(invest.statusName!),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),
                                          // 计划执行信息
                                          invest.periods != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Plan to execute ${invest.periods} times'),
                                                    // 可以根据需求添加更多按钮或者文本
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )));
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
            errorMsg: state.errorMsg),
        floatingActionButton: state.investmentConfig != null &&
                state.investmentConfig!.investmentCreation == false
            ? Container()
            : FloatingActionButton(
                onPressed: () {
                  // 这里是点击按钮时的操作
                  dispatch(InvestmentActionCreator.addAction());
                },
                child: const Icon(Icons.add), // 按钮图标
              ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // 右下角
      ));
}
