import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../pages/main_page/hd_wallet_list_page/view/lazy_indexed_stack.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/login_bean.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MultipleLoginState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  final currentLoginMethod = state.loginMethodList.isNotEmpty &&
          state.currentIndex >= 0 &&
          state.currentIndex < state.loginMethodList.length
      ? state.loginMethodList[state.currentIndex]
      : null;
  List<LoginMethod> loginMethods = state.loginMethodList
      .asMap()
      .entries
      .where((entry) => entry.key != state.currentIndex)
      .map((entry) => entry.value)
      .toList();
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(currentLoginMethod?.name ?? ''),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(viewService.context).pop(),
      ),
      // actions: [
      //   if (state.loadStatus == LoadType.loadSuccess)
      //     TextButton(
      //         onPressed: () {}, child: Text(languageResource.switchLogin))
      // ],
    ),
    body: BasePageLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        buildBody: (bool isLoadSuccess) {
          if (!isLoadSuccess) {
            return const SizedBox();
          }

          if (state.loginMethodList.isEmpty) {
            return const _MultipleLoginSkeleton();
          }

          return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: LazyIndexedStack(
                          index: state.currentIndex,
                          itemCount: state.loginMethodList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = state.loginMethodList[index];
                            if (item.code == 'EMAIL_PASSWORD') {
                              return AppRoute.global
                                  .buildPage('emailPasswordPage', null);
                            } else if (item.code == 'MOBILE_PASSWORD') {
                              return AppRoute.global.buildPage(
                                  'phonePasswordPage',
                                  {'countryList': state.countryList});
                            } else if (item.code == 'EMAIL_OTP') {
                              return AppRoute.global
                                  .buildPage('emailOtpPage', null);
                            } else if (item.code == 'MOBILE_OTP') {
                              return AppRoute.global.buildPage('phoneOtpPage',
                                  {'countryList': state.countryList});
                            } else if (item.code == 'NFC_TOUCH') {
                              return AppRoute.global.buildPage('phoneOtpPage',
                                  {'countryList': state.countryList});
                            } else {
                              throw Exception(
                                  "Haven't implement ${item.code} login method.");
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                bool isPhone = currentLoginMethod?.code ==
                                        'MOBILE_PASSWORD' ||
                                    currentLoginMethod?.code == 'MOBILE_OTP';
                                Navigator.of(viewService.context).pushNamed(
                                    'forgotPasswordPage',
                                    arguments: {'isPhone': isPhone});
                              },
                              child: Text(
                                languageResource.forgotPwd,
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () => dispatch(
                                  MultipleLoginActionCreator.onRegister()),
                              child: Text(
                                languageResource.gotoRegister,
                                style: const TextStyle(fontSize: 12.0),
                              )),
                        ],
                      ),
                      const Spacer(),
                      if (loginMethods.isNotEmpty)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 24.0, bottom: 16.0),
                              child: Text(
                                '---- Other Login Methods -----',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: loginMethods.map((method) {
                                return GestureDetector(
                                  onTap: () => dispatch(
                                      MultipleLoginActionCreator
                                          .onLoginTypeClick(method)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: method.imageUrl != null
                                              ? Image.network(method.imageUrl!,
                                                  fit: BoxFit.cover)
                                              : const Icon(Icons.person_outline,
                                                  size: 28, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          method.name ?? '',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                    ],
                  )));
        }),
  );
}

class _MultipleLoginSkeleton extends StatelessWidget {
  const _MultipleLoginSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 18, width: 80, color: Colors.black12),
                Container(height: 18, width: 80, color: Colors.black12),
              ],
            ),
            const Spacer(),
            Container(height: 16, width: 180, color: Colors.black12),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 40, color: Colors.black12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
