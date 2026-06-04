import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ChangeLanguageState state, Dispatch dispatch, ViewService viewService) {
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
          title: Text(languageResource.changeLan)),
      body: PageDataLoadingView(
          onLoadSuccess: () {
            return SmartRefresher(
                onRefresh: () {},
                controller: state.refreshController,
                child: state.languageList.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: state.languageList.length,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          var languageMode = state.languageList[index];

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 30.0, right: 15.0),
                                onTap: () => dispatch(
                                    ChangeLanguageActionCreator.onSelectLan(
                                        index)),
                                title: Row(
                                  children: [
                                    LoadImage(
                                      languageMode.imageUrl!,
                                      width: 20,
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(languageMode.localeName!),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                  ],
                                ),
                                trailing: state.currentIndex == index
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.grey[800],
                                      )
                                    : null,
                              ),
                            ],
                          );
                        })
                    : const EmptyListView());
          },
          loadStatus: state.loadStatus));
}
