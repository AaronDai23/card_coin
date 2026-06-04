import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(ScanState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource;
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
            languageResource.getWelcomeTips('AirChip3'),
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            languageResource.homePageTips,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
          CCButton(
            child: Center(child: Text(state.languageResource.scanCard)),
            onPressed: () => dispatch(ScanActionCreator.onScanCard()),
          )
        ],
      ),
    ),
  );
}
