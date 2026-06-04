import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../generated/l10n.dart';
import '../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CardManagerState state, Dispatch dispatch, ViewService viewService) {
  var adapter = viewService.buildAdapter()!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(S.current.cardManager),
      actions: [
        TextButton(
            onPressed: () =>
                dispatch(CardManagerActionCreator.onAddCardClick()),
            child: Text(S.current.add))
      ],
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(CardManagerActionCreator.onShowLoading());
        dispatch(CardManagerActionCreator.onLoadData());
      },
      buildBody: (isSuccess) {
        return isSuccess
            ? SmartRefresher(
                enablePullUp: true,
                enablePullDown: true,
                controller: state.refreshController,
                onRefresh: () {
                  state.currentPage = 1;
                  dispatch(CardManagerActionCreator.onLoadData());
                },
                onLoading: () {
                  dispatch(
                      CardManagerActionCreator.onLoadData(isLoadMore: true));
                },
                child: ListView.builder(
                    itemBuilder: adapter.itemBuilder!,
                    itemCount: adapter.itemCount))
            : const SizedBox();
      },
    ),
  );
}
