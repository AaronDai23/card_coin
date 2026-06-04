import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CommonInfoState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          title: Text(state.docTitle ?? '')),
      body: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onReload: () {
          dispatch(CommonInfoActionCreator.onShowLoading());
          dispatch(CommonInfoActionCreator.onLoadData());
        },
        onLoadSuccess: () {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [Html(data: state.docContent ?? '')],
            ),
          );
        },
      ));
}
