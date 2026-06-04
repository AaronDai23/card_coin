import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'package:keyboard_service/keyboard_service.dart';

import '../../../../generated/l10n.dart';
import '../../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    AddDetailState state, Dispatch dispatch, ViewService viewService) {
  return KeyboardAutoDismiss(
    scaffold: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(viewService.context).pop(),
          ),
          title: Text(state.name),
        ),
        body: PageDataLoadingView(
            loadStatus: state.loadStatus,
            errorMsg: state.errorMsg,
            onReload: () {
              dispatch(AddDetailActionCreator.onShowLoading());
              dispatch(AddDetailActionCreator.onLoadData());
            },
            onLoadSuccess: () {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.withAlpha(100)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10.0))),
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  if ((state.typeDetail!.prefix ?? '') != '')
                                    Text(
                                      state.typeDetail!.prefix!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  Expanded(
                                    child: TextField(
                                      maxLines: 1,
                                      controller: state.valueController,
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        hintText: S.current.enterHint,
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 0),
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.withAlpha(80)),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            S.current.operateTutorial,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Html(
                              anchorKey: state.staticAnchorKey,
                              data: state.typeDetail?.description ?? '')
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        if (state.id != null)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    dispatch(
                                        AddDetailActionCreator.onDeleteLink());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      S.current.delete,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ))),
                            ),
                          ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                dispatch(
                                    AddDetailActionCreator.onButtonClick());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  state.id == null
                                      ? S.current.save
                                      : S.current.modify,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })),
  );
}
