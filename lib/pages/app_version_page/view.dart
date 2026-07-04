import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';

import '../../widget/app_config.dart';
import '../../widget/base_page_loading.dart';
import 'state.dart';

Widget buildView(
    AppVersionState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(state.title ?? languageResource.appVersion),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(viewService.context).pop(),
      ),
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      buildBody: (bool isLoadSuccess) {
        if (isLoadSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: LoadAssetImage(
                    '${AppConfig.of(viewService.context).appInternalId == AppType.pro ? '2' : '1'}/app_logo',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                  child: Text(
                    AppConfig.of(viewService.context).appInternalId ==
                            AppType.bestWish
                        ? 'Chipbase'
                        : 'OfferVas',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languageResource.currentVersion),
                      Text(state.packageInfo != null
                          ? '${state.packageInfo!.version}.${state.packageInfo!.buildNumber}'
                          : ''),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                // InkWell(
                //   onTap: () =>
                //       dispatch(AppVersionActionCreator.onSelectLanguage()),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 18.0, horizontal: 18.0),
                //     child: Row(
                //       children: [
                //         Text(languageResource.language),
                //         Spacer(),
                //         Text(
                //           state.languageList[state.currentIndex].localeName!,
                //           style: TextStyle(color: Colors.grey),
                //         ),
                //         Icon(
                //           Icons.arrow_forward_ios,
                //           color: Colors.grey,
                //           size: 16,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    ),
  );
}
