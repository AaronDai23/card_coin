import 'package:card_coin/bean/light_spark_transactions.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/utils/card_coin_util.dart';
import 'package:card_coin/utils/number_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    LightningNetDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Lightning Network'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(viewService.context).pop();
              // dispatch(HDWalletListActionCreator.onShowCardInfoList());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: PageDataLoadingView(
        onLoadSuccess: () {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Column(children: [
                    ListTile(
                      title: const Text("Total",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 14, height: 1.2)),
                      subtitle: Text(
                          state.flashBalanceDetail != null
                              ? '+${NumberUtils.formatNumber(num.tryParse(state.flashBalanceDetail!.amountValue)!, 10)} ${state.flashBalanceDetail!.amountUnit} (${state.flashBalanceDetail!.usdDisplayAmount}) (${state.homeSeconds}s)'
                              : "+ 0 (~\$ 0) (${state.homeSeconds}s)",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CCButton(
                              onPressed: () {
                                dispatch(LightningNetDetailActionCreator
                                    .onReceive());
                              },
                              child: const Text("Receive")),
                          CCButton(
                              onPressed: () {
                                dispatch(LightningNetDetailActionCreator
                                    .onSendInvoice());
                              },
                              child: const Text("Send")),
                          CCButton(
                              onPressed: () {
                                dispatch(LightningNetDetailActionCreator
                                    .onWithdrawLightning());

                                // dispatch(LightningNetDetailActionCreator
                                //     .onSendLightningNetAlert());
                              },
                              child: const Text("Withdrawal"))
                        ])
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: SmartRefresher(
                        enablePullUp: true,
                        enablePullDown: true,
                        controller: state.refreshController,
                        onRefresh: () {
                          // 下拉
                          state.currentPage = 1;
                          dispatch(
                              LightningNetDetailActionCreator.onLoadData());
                        },
                        onLoading: () {
                          // 上拉
                          dispatch(LightningNetDetailActionCreator.onLoadData(
                              isLoadMore: true));
                        },
                        child: state.historyTransactions.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: state.historyTransactions.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(height: 1);
                                },
                                itemBuilder: (context, index) {
                                  LightSparkTransactions transaction =
                                      state.historyTransactions[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                transaction.amountTypeName,
                                              ),
                                              Text(
                                                transaction.statusName,
                                                style: const TextStyle(
                                                    fontSize: 12.0),
                                              )
                                            ]),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            transaction.amountTypeName
                                                    .toLowerCase()
                                                    .contains("outgoing")
                                                ? Text(
                                                    '-${transaction.primaryAmount} ${transaction.primaryUnit}',
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  )
                                                : Text(
                                                    '+${transaction.primaryAmount} ${transaction.primaryUnit}',
                                                    style: const TextStyle(
                                                        color: Colors.green)),
                                            if (transaction.createTime != null)
                                              Text(
                                                CardCoinUtil.timeStampToTime(
                                                    transaction.createTime!),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                          ],
                                        ),
                                        if (transaction.remarks.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(transaction.remarks),
                                          ),
                                      ],
                                    ),
                                  );
                                })
                            : const EmptyListView()))
              ]);
        },
        loadStatus: state.loadStatus,
      ));
}
