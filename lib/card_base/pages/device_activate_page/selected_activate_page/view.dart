import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SelectedActivateState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.packageActivate),
    ),
    backgroundColor: Colors.grey.withOpacity(0.2),
    body: SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: state.packageList.length,
            itemBuilder: (_, index) {
              final item = state.packageList[index];
              double progress = NumUtil.getNumByValueDouble(
                      item.packageActiveCount! / item.totalPackageCount!, 4)!
                  .toDouble();
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.packageNumber ?? ''),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(child: Text(item.packageRemarks ?? '')),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                          child: Text(
                              '${languageResource.titleTotalNum}${languageResource.getUnitPieces('${item.packageActiveCount}/${item.totalPackageCount}')}')),
                      const SizedBox(
                        height: 20,
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
                    ],
                  ),
                ),
              );
            },
            physics: const NeverScrollableScrollPhysics(),
          ),
          const SizedBox(
            height: 20,
          ),
          CCButton(
            horizontalPadding: 20,
            onPressed: () =>
                dispatch(SelectedActivateActionCreator.onActivateClick()),
            child: Text(languageResource.activateCard),
          )
        ],
      ),
    ),
  );
}
