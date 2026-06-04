import 'dart:convert';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../widget/base_page_loading.dart';
import '../../../../widgets/buttons_view.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    TabShareState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(TabShareActionCreator.onShowLoading());
        dispatch(TabShareActionCreator.onLoadDomain());
      },
      buildBody: (isSuccess) {
        Uint8List? bytes;
        if (state.linkDomain!.qrCode?.isNotEmpty ?? false) {
          bytes = const Base64Decoder()
              .convert(state.linkDomain!.qrCode!.split(',')[1]);
        }

        if (isSuccess) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        languageResource.shareProfile,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey,
                          child: bytes != null
                              ? Image.memory(
                                  bytes,
                                  fit: BoxFit.contain,
                                )
                              : const Center(child: Text('二维码为空')),
                        ),
                      ),
                      GestureDetector(
                          onTap: bytes != null
                              ? () => dispatch(
                                  TabShareActionCreator.onSaveImage(bytes!))
                              : null,
                          behavior: HitTestBehavior.opaque,
                          child: Text(languageResource.tapSave)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFf4f5f7),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Text(
                                      languageResource.editQr,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ))),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Text(
                                      languageResource.share,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: const BorderSide(color: Color(0xFFE5E5E5))),
                        color: const Color(0xFFf4f5f7),
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(children: [
                              Expanded(child: Text(state.linkDomain!.domain!)),
                              const SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: state.linkDomain!.domain!));
                                    showToast(languageResource.conySuccess);
                                  },
                                  child: const Icon(Icons.copy))
                            ])),
                      ),
                    ],
                  ),
                ),
              ),
              const ButtonsView(
                routeName: 'tabSharePage',
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    ),
  );
}
