import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SingleActivateState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.singleActivate),
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onLoadSuccess: () {
        var activateSummary = state.activateSummary!;
        double progress = NumUtil.getNumByValueDouble(
                activateSummary.activeCount! / activateSummary.totalCount!, 4)!
            .toDouble();
        // double progress = 0.35;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
          child: Column(
            children: [
              Text(
                  '${languageResource.titleTotalNum}${languageResource.getUnitPieces('${activateSummary.activeCount}/${activateSummary.totalCount}')}'),
              const SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 25,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  Positioned(
                    left: 4,
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: (progress * 100).toInt(),
                          child: Text(
                            '${(progress * 100).toStringAsFixed(2)}%',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: ((1 - progress) * 100).toInt(),
                          child: const SizedBox(),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 2,
                child: Center(
                    child: CCButton(
                  horizontalPadding: 40,
                  onPressed: () {
                    if (progress == 1) {
                      Navigator.of(viewService.context).pop();
                    } else {
                      dispatch(SingleActivateActionCreator.onScanClick());
                    }
                  },
                  child: Text(progress != 1
                      ? languageResource.scanActivate
                      : languageResource.confirm),
                )),
              ),
            ],
          ),
        );
      },
    ),
  );
}
