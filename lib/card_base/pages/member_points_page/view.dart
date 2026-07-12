import 'package:card_coin/card_base/bean/points_history_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MemberPointsState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      automaticallyImplyLeading: (ModalRoute.of(viewService.context)
              ?.settings
              .arguments as Map?)?['fromDeepLink'] !=
          true,
      title: Text(state.title),
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onLoadSuccess: () {
        return Column(
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage(
                        'assets/images/asset_top_bg.png',
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languageResource.pointsBalance,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7))),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        Text(
                            '${state.memberPointsInfo!.symbol} ${state.memberPointsInfo!.currentBalance}',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white.withOpacity(0.7))),
                        Text(
                            ' ≈ ${state.memberPointsInfo!.symbolAround} ${state.memberPointsInfo!.currentBalanceAround}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7))),
                      ]),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languageResource.yesterdayPoints,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7))),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(children: [
                              Text(
                                  '${state.memberPointsInfo!.symbol} ${state.memberPointsInfo!.yesterdayIncome}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7))),
                              Text(
                                  ' ≈ ${state.memberPointsInfo!.symbolAround} ${state.memberPointsInfo!.yesterdayIncomeAround}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7))),
                            ]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languageResource.totalPoints,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7))),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(children: [
                              Text(
                                  '${state.memberPointsInfo!.symbol} ${state.memberPointsInfo!.totalIncome}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7))),
                              Text(
                                  ' ≈ ${state.memberPointsInfo!.symbolAround} ${state.memberPointsInfo!.totalIncomeAround}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7))),
                            ]),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                controller: state.refreshController,
                onRefresh: () {
                  state.currentPage = 1;
                  dispatch(MemberPointsActionCreator.onLoadData());
                },
                onLoading: () {
                  dispatch(
                      MemberPointsActionCreator.onLoadData(isLoadMore: true));
                },
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = const Text("Pull load more data!");
                    } else if (mode == LoadStatus.loading) {
                      body = const CircularProgressIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const Text("Load failed");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("Release to load data.");
                    } else {
                      if (state.list.length < 20) {
                        body = const SizedBox.shrink(); // 不显示任何东西
                      } else {
                        body = const Text("No more data.");
                      }
                    }
                    return SizedBox(
                      height: 60,
                      child: Center(child: body),
                    );
                  },
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    PointsHistory history = state.list[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                history.amountTypeName ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${history.amountDirection == 'POSITIVE' ? '+' : '-'}${history.amount}',
                                style: TextStyle(
                                    color: history.amountDirection == 'POSITIVE'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateUtil.formatDateMs(history.createTime!),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                history.currentBalance! > 0
                                    ? 'Saldo ${history.symbol!} ${history.currentBalance}'
                                    : '',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    ),
  );
}
