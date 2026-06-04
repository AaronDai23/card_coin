import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(MainState state, Dispatch dispatch, ViewService viewService) {
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
        title: Text(languageResource.walletMainTitle),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(viewService.context).pushNamed('checkCardPage');
              },
              icon: const Icon(Icons.more_horiz))
        ],
      ),
      body: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onReload: () {
          dispatch(MainActionCreator.onShowLoading());
          dispatch(MainActionCreator.onLoadDefaultCurrency());
        },
        onLoadSuccess: () {
          return Material(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          languageResource.welcomeToBestWish,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          languageResource.homeSubTips,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 800,
                  margin: const EdgeInsets.only(top: 600, right: 30, left: 30),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            dispatch(MainActionCreator.onScanCard());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              languageResource.scanCard,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ));
}
