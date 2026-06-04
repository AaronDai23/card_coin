import 'package:card_coin/bean/coin_message_item.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/utils/card_coin_util.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CoinMessageListState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text("Coin Messages"),
      ),
      body: BasePageLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {
            dispatch(CoinMessageListActionCreator.onShowLoading());
            dispatch(CoinMessageListActionCreator.onLoadData());
          },
          buildBody: (isSuccess) {
            if (isSuccess) {
              return state.items.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: SmartRefresher(
                            enablePullUp: true,
                            enablePullDown: true,
                            controller: state.refreshController,
                            onRefresh: () {
                              state.currentPage = 1;
                              dispatch(
                                  CoinMessageListActionCreator.onLoadData());
                            },
                            onLoading: () {
                              dispatch(CoinMessageListActionCreator.onLoadData(
                                  isLoadMore: true));
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                CoinMessageItem noticeMessage =
                                    state.items[index];
                                var monthDate = CardCoinUtil.timeStampToTime(
                                    noticeMessage.createTime);

                                return ListTile(
                                  horizontalTitleGap: 5.0,
                                  onTap: () {
                                    Navigator.of(viewService.context).pushNamed(
                                        'coinMessageDetailPage',
                                        arguments: {
                                          'noticeId': noticeMessage.id
                                        });
                                  },
                                  title: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "sender:${noticeMessage.sender}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Text(
                                        monthDate,
                                        style: const TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            noticeMessage.message,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.0,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: state.items.length,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const EmptyListView();
            } else {
              return const SizedBox();
            }
          }));
}
