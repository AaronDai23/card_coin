import 'package:card_coin/card_base/pages/device_activate_page/package_activate_page/action.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    PackageActivateState state, Dispatch dispatch, ViewService viewService) {
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
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onLoadSuccess: () {
        var activateSummary = state.activateSummary!;
        double progress = NumUtil.getNumByValueDouble(
                activateSummary.activePackageCount! /
                    activateSummary.totalPackageCount!,
                4)!
            .toDouble();
        final enableList = state.packageList.where(
            (item) => item.packageActiveCount! < item.totalPackageCount!);
        bool allSelected = true;
        if (enableList.isEmpty) {
          allSelected = false;
        } else {
          for (int i = 0; i < enableList.length; i++) {
            if (!state.selectedList.contains(i)) {
              allSelected = false;
            }
          }
        }

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
                child: Column(
                  children: [
                    Text(
                        '${languageResource.titlePackageNum}${languageResource.getUnitPackage('${activateSummary.activePackageCount}/${activateSummary.totalPackageCount}')}'),
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
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: GridView.builder(
                      itemCount: state.packageList.length,
                      itemBuilder: (_, index) {
                        final item = state.packageList[index];
                        double itemProgress = NumUtil.getNumByValueDouble(
                                item.packageActiveCount! /
                                    item.totalPackageCount!,
                                4)!
                            .toDouble();
                        return Card(
                          margin: const EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(item.packageNumber ?? ''),
                                    ),
                                    Text(
                                        '${(itemProgress * 100).toStringAsFixed(2)}%'),
                                    Text(
                                        '${languageResource.titleTotalNum}${item.packageActiveCount}/${item.totalPackageCount}'),
                                  ],
                                ),
                                if (item.packageActiveCount! <
                                    item.totalPackageCount!)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Checkbox(
                                        value:
                                            state.selectedList.contains(index),
                                        onChanged: (value) => dispatch(
                                            PackageActivateActionCreator
                                                .onCheckClick(index))),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                    )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: allSelected,
                          onChanged: enableList.isNotEmpty
                              ? (value) {
                                  List<int> list = [];
                                  if (!allSelected) {
                                    list = List.generate(
                                        state.packageList.length,
                                        (index) => index);
                                  }
                                  dispatch(PackageActivateActionCreator
                                      .onUpdateSelectedList(list));
                                }
                              : null),
                      Text(languageResource.selectAll),
                      const Spacer(),
                      CCButton(
                        onPressed: state.selectedList.isNotEmpty
                            ? () => dispatch(
                                PackageActivateActionCreator.onActivateClick())
                            : null,
                        child: Text(languageResource.gotoActivate),
                      )
                    ],
                  ),
                  Center(
                      child: Text(
                          '${state.selectedList.length}/${state.packageList.length}')),
                ],
              ),
            )
          ],
        );
      },
    ),
  );
}
