import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/pages/main_page/hd_wallet_page/transaction_detail_page/action.dart';
import 'package:card_coin/pigeons/messages.dart';
import 'package:card_coin/utils/card_coin_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'state.dart';

Widget buildView(
    TransactionDetailState state, Dispatch dispatch, ViewService viewService) {
  var type = state.type;
  var wallet = state.wallet;
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
          title: Text(languageResource.transactionDetail)),
      body: PageDataLoadingView(
          onLoadSuccess: () {
            return SmartRefresher(
                onRefresh: () =>
                    dispatch(TransactionDetailActionCreator.onRefresh()),
                controller: state.refreshController,
                child: state.historyTransactions.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: state.historyTransactions.length,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          TransactionsHistory transaction =
                              state.historyTransactions[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        type == 1
                                            ? languageResource.withdraw
                                            : languageResource.recharge,
                                        style: TextStyle(
                                            color: type == 1
                                                ? Colors.red
                                                : Colors.green),
                                      ),
                                      Text(
                                        transaction.status == 1
                                            ? (type == 1
                                                ? languageResource
                                                    .transferredOut
                                                : languageResource
                                                    .transferredIn)
                                            : (transaction.status == 0
                                                ? languageResource.processing
                                                : languageResource.failed),
                                        style: const TextStyle(fontSize: 12.0),
                                      )
                                    ]),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${transaction.value} ${wallet.currencyData.symbol}'),
                                    Text(
                                      CardCoinUtil.getDateScope(
                                          checkDate: transaction.time),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })
                    : const EmptyListView());
          },
          loadStatus: state.loadStatus));
}
