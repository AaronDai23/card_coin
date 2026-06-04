import 'package:card_coin/card_base/widgets/diagnostic_widget.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../bean/diagnostic_bean.dart';
import 'state.dart';

Widget buildView(
    NetworkCheckState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.networkCheck),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoadAssetImage(
                'md_diagnostic_phone',
                width: 46,
                height: 46,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DiagnosticStatusAnimation(state.resultList[0].state, 60),
              ),
              const LoadAssetImage('md_diagnostic_network',
                  width: 46, height: 46, color: Colors.black),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DiagnosticStatusAnimation(state.resultList[1].state, 60),
              ),
              const LoadAssetImage('md_diagnostic_server',
                  width: 46, height: 46, color: Colors.black),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),
          Column(
            children: state.resultList
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DiagnosticStatusView(
                            state: e.state,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            e.name,
                            maxLines: 2,
                            style: TextStyle(
                                color: e.state == ResultState.fail
                                    ? Colors.red
                                    : e.signal != NetworkSignal.strong
                                        ? Colors.yellow.shade800
                                        : Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (state.resultList[0].state == ResultState.fail)
            Text(languageResource.checkPhoneNetwork,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red)),
          if (state.resultList[1].state == ResultState.fail)
            Text(
              languageResource.serverContactUs,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red),
            ),
        ],
      ),
    ),
  );
}
