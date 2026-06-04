import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvestmentActiveState state, Dispatch dispatch, ViewService viewService) {
  return WillPopScope(
      onWillPop: () async {
        dispatch(InvestmentActiveActionCreator.onBackClick());
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: Theme.of(viewService.context)
                    .extension<GradientTheme>()!
                    .primaryGradient,
              ),
            ),
            title: const Text('Investment Active'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                dispatch(InvestmentActiveActionCreator.onBackClick());
              },
            ),
          ),
          body: PageDataLoadingView(
            loadStatus: state.loadStatus,
            errorMsg: state.errorMsg,
            onReload: () {
              dispatch(InvestmentActiveActionCreator.onLoadDefaultCurrency());
            },
            onLoadSuccess: () {
              if (state.investmentConfig?.investmentAssetDestination ==
                      'WITHDRAW' ||
                  state.investmentConfig?.investmentAssetDestination ==
                      'CENTRALIZED') {
                return Material(
                    child: state.activeStatus != ActivitedStatus.scanActivite &&
                            state.activeStatus != ActivitedStatus.finActivite
                        ? getNoramlWidget(state, dispatch, viewService)
                        : getNorNetWidget(state, dispatch, viewService));
              } else {
                return Material(
                    child: state.activeStatus != ActivitedStatus.scanActivite &&
                            state.activeStatus != ActivitedStatus.finActivite
                        ? getNoramlWidget(state, dispatch, viewService)
                        : getNetWidget(state, dispatch, viewService));
              }
            },
          )));
}

Widget getNoramlWidget(
    InvestmentActiveState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    children: [
      const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Retry to activate your card',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 800,
        margin: const EdgeInsets.only(top: 400, right: 30, left: 30),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  dispatch(InvestmentActiveActionCreator.onScanCard());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: const Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'Tap Card',
                    style: TextStyle(color: Colors.white),
                  ),
                )))
          ],
        ),
      )
    ],
  );
}

Widget getNetWidget(
    InvestmentActiveState state, Dispatch dispatch, ViewService viewService) {
  int count = 0;
  if ((state.progress == 100)) {
    count = 1;
  } else if (state.progress == 100) {
    count = 2;
  }

  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // : Alignment.center,
      children: [
        // 自定义条形进度条，带半圆两端
        LinearProgressBar(
          maxSteps: 2,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Linear progress
          currentStep: count,
          progressColor: const Color(0xff002dfc),
          backgroundColor: Colors.grey[200]!,
          // borderRadius: BorderRadius.circular(10), //  NEW
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          state.activeStatus == ActivitedStatus.scanActivite
              ? 'SynsWalletInfo...'
              : 'Activited',
          style: const TextStyle(
            color: Color(0xff002dfc),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget getNorNetWidget(
    InvestmentActiveState state, Dispatch dispatch, ViewService viewService) {
  int count = 0;
  if ((state.progress == 50)) {
    count = 1;
  } else if (state.progress == 100) {
    count = 2;
  }

  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // : Alignment.center,
      children: [
        // 自定义条形进度条，带半圆两端
        LinearProgressBar(
          maxSteps: 2,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Linear progress
          currentStep: count,
          progressColor: const Color(0xff002dfc),
          backgroundColor: Colors.grey[200]!,
          // borderRadius: BorderRadius.circular(10), //  NEW
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          state.activeStatus == ActivitedStatus.scanActivite
              ? 'Activiting...'
              : 'Activited',
          style: const TextStyle(
            color: Color(0xff002dfc),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
