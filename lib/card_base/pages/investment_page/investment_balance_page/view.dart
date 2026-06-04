import 'package:card_coin/card_base/bean/investment_balance.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvestmentBalanceState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          title: const Text('Investment Balance')),
      body: BasePageLoadingView(
          onReload: () {},
          buildBody: (isLoadSuccess) {
            if (isLoadSuccess) {
              if (state.list.isNotEmpty) {
                return SmartRefresher(
                    controller: state.refreshController,
                    onRefresh: () {
                      dispatch(
                          InvestmentBalanceActionCreator.onLoadData(isLoadMore: true));
                      // state.currentPage = 1;
                      // dispatch(InviteListActionCreator.onLoadData());
                    },
                    onLoading: () {
                      // dispatch(
                      //     InviteListActionCreator.onLoadData(isLoadMore: true));
                    },
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        InvestmentBalance info = state.list[index];
                        return GestureDetector(
                            onTap: () {
                              dispatch(InvestmentBalanceActionCreator
                                  .onSelectedAction(index));
                            },
                            child: Card(
                              color: Colors.grey[200], // Light blue background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    // Amount and BTC amount
                                    Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        LoadImage(
                                          info.imageUrl ?? '',
                                          width: 23,
                                          height: 23,
                                        ),
                                        Text(' ${info.symbol}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                    Column(children: [
                                      Text('${info.balance}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      Text('${info.usdDisplayAmount}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ))
                                    ])
                                  ],
                                ),
                              ),
                            ));
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
