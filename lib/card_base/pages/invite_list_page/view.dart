import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    InviteListState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.inviteDetail),
    ),
    body: BasePageLoadingView(
        onReload: () {
          dispatch(InviteListActionCreator.onShowLoading());
          dispatch(InviteListActionCreator.onLoadData(true));
        },
        buildBody: (isLoadSuccess) {
          if (isLoadSuccess) {
            if (state.list.isNotEmpty) {
              return SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                controller: state.refreshController,
                onRefresh: () {
                  state.currentPage = 1;
                  dispatch(InviteListActionCreator.onLoadData(true));
                },
                onLoading: () {
                  dispatch(InviteListActionCreator.onLoadData(true));
                },
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var inviteUser = state.list[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, right: 20.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Material(
                                color: Colors.grey.withAlpha(100),
                                borderRadius: BorderRadius.circular(6.0),
                                child: SizedBox(
                                  width: 28.0,
                                  height: 28.0,
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                inviteUser.phone ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            inviteUser.registerTime ?? '',
                            style: const TextStyle(
                                fontSize: 14.0, color: Color(0xFFCCCCCC)),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: state.list.length,
                ),
              );
            } else {
              return const EmptyListView();
            }
          } else {
            return const SizedBox();
          }
        },
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg),
  );
}
