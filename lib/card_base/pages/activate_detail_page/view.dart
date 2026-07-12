import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ActivateDetailState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  final gradientTheme =
      Theme.of(viewService.context).extension<GradientTheme>()!;
  String activateDetail =
      languageResource.activateDetail.replaceAll('\\n', '\n');
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: (ModalRoute.of(viewService.context)
              ?.settings
              .arguments as Map?)?['fromDeepLink'] !=
          true,
      title: Text(state.title ?? ''),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradientTheme.primaryGradient,
        ),
      ),
    ),
    backgroundColor: Colors.grey.shade200,
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activateDetail,
                    style: const TextStyle(height: 2, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    languageResource.activateDetailTips,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  dispatch(ActivateDetailActionCreator.onActivateClick());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    languageResource.gotoActivate,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))),
          ),
        ],
      ),
    ),
  );
}
