import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    DeviceActivateState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(state.title),
      actions: [
        if ((state.validateMethodList?.length ?? 0) > 1)
          TextButton(
              onPressed: () =>
                  dispatch(DeviceActivateActionCreator.onShowMethodList()),
              child: Text(languageResource.switchActivate))
      ],
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      onLoadSuccess: () {
        return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (_) {
                    var item = state.validateMethodList![state.currentIndex];
                    if (item.code == 'EMAIL') {
                      return AppRoute.global.buildPage('emailActivatePage',
                          {'uuid': state.uuid, 'method': item});
                    } else if (item.code == 'MOBILE') {
                      return AppRoute.global.buildPage('phoneActivatePage',
                          {'uuid': state.uuid, 'method': item});
                    } else {
                      throw Exception(
                          "Haven't implement ${item.code} login method.");
                    }
                  }),
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}
