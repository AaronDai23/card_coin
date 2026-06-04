import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../http/address.dart';
import '../../../pages/main_page/hd_wallet_list_page/view/lazy_indexed_stack.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    RegisterState state, Dispatch dispatch, ViewService viewService) {
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
      title: Text(state.loadStatus == LoadType.loadSuccess
          ? state.registerMethodList[state.currentIndex].name ?? ''
          : ''),
      actions: [
        if (state.loadStatus == LoadType.loadSuccess)
          TextButton(
              onPressed: () =>
                  dispatch(RegisterActionCreator.onShowRegisterList()),
              child: Text(languageResource.changeRegister))
      ],
    ),
    body: PageDataLoadingView(
      loadStatus: state.loadStatus,
      onLoadSuccess: () {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LazyIndexedStack(
                  index: state.currentIndex,
                  itemCount: state.registerMethodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = state.registerMethodList[index];
                    if (item.code == 'EMAIL') {
                      return AppRoute.global.buildPage('emailRegisterPage', {
                        'index': index,
                        'countryList': state.countryList,
                        'uid': state.uid,
                        'taskItemId': state.taskItemId
                      });
                    } else if (item.code == 'MOBILE') {
                      return AppRoute.global.buildPage('phoneRegisterPage', {
                        'index': index,
                        'countryList': state.countryList,
                        'uid': state.uid,
                        'taskItemId': state.taskItemId
                      });
                    } else {
                      throw Exception(
                          "Haven't implement ${item.code} login method.");
                    }
                  },
                ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                    onPressed: () =>
                        dispatch(RegisterActionCreator.onRegisterClick()),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        languageResource.agreeAndRegister,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => dispatch(
                            RegisterActionCreator.onUpdateAgree(
                                !state.isAgree)),
                        child: Icon(
                          state.isAgree
                              ? Icons.radio_button_on
                              : Icons.radio_button_off,
                          size: 18,
                          color: state.isAgree ? Colors.blue : Colors.black,
                        )),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => dispatch(
                                RegisterActionCreator.onUpdateAgree(
                                    !state.isAgree)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                languageResource.agreed,
                                style: const TextStyle(
                                    color: Color(0xFF6F6F6F), fontSize: 11),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(viewService.context)
                                .pushNamed('commonInfoPage', arguments: {
                              'docUrl': NetworkAddress.userAgreementUrl
                            }),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                languageResource.userAgreement,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10),
                              ),
                            ),
                          ),
                          Text(languageResource.and,
                              style: const TextStyle(
                                  color: Color(0xFF6F6F6F), fontSize: 10)),
                          GestureDetector(
                            onTap: () => Navigator.of(viewService.context)
                                .pushNamed('commonInfoPage', arguments: {
                              'docUrl': NetworkAddress.termsPrivacyUrl
                            }),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                languageResource.privacyPolicy,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                    child: TextButton(
                        onPressed: () => Navigator.of(viewService.context)
                            .pushReplacementNamed('multipleLoginPage'),
                        child: const Text(
                          'Already have account? Go login',
                          style: TextStyle(fontSize: 12),
                        )))
              ],
            ),
          ),
        );
      },
      onReload: () {},
    ),
  );
}
