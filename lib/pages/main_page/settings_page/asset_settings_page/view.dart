import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AssetSettingsState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(languageResource.assetSettings),
    ),
    backgroundColor: Colors.grey.withOpacity(0.2),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(AssetSettingsActionCreator.onShowLoading());
        dispatch(AssetSettingsActionCreator.onLoadData());
      },
      onLoadSuccess: () {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (_, index) {
                  final item = state.list[index];
                  bool allSelected = item.networks!
                      .every((element) => element.display ?? false);
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Row(
                      children: [
                        Expanded(child: Text(item.name ?? '')),
                        Checkbox(
                            value: allSelected,
                            onChanged: (value) => dispatch(
                                AssetSettingsActionCreator.onSectionClick(
                                    index, value ?? false)))
                      ],
                    ),
                    children: item.networks!
                        .asMap()
                        .entries
                        .map((e) => Padding(
                            padding: const EdgeInsets.only(
                                left: 30, top: 10, bottom: 10, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(e.value.networkName ?? '')),
                                Checkbox(
                                    value: e.value.display ?? false,
                                    onChanged: (value) => dispatch(
                                        AssetSettingsActionCreator.onItemClick(
                                            index, e.key, value ?? false)))
                              ],
                            )))
                        .toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 30.0, left: 30.0, bottom: 50, top: 20),
              child: CCButton(
                child: Center(child: Text(languageResource.save)),
                onPressed: () =>
                    dispatch(AssetSettingsActionCreator.onSaveClock()),
              ),
            )
          ],
        );
      },
    ),
  );
}
