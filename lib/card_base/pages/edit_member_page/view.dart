import 'package:card_coin/card_base/extensions/ext_string.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    EditMemberState state, Dispatch dispatch, ViewService viewService) {
  var cardNum = state.cardInfo.cardNum ?? '';
  if (cardNum.isNotEmpty && cardNum.length >= 12) {
    cardNum = cardNum.replaceRange(4, 12, '********');
    print('cardNum:$cardNum');
  }
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
      title: Text(languageResource.addMemberCard),
    ),
    body: BasePageLoadingView(
      loadStatus: state.loadStatus,
      errorMsg: state.errorMsg,
      onReload: () {
        dispatch(EditMemberActionCreator.onShowLoading());
        dispatch(EditMemberActionCreator.onLoadData());
      },
      buildBody: (isLoadSuccess) {
        return isLoadSuccess
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        languageResource.cardNo,
                      ),
                      trailing: Text(
                        cardNum.stringSeprate(count: 4, separator: ' '),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        languageResource.cardBrand,
                      ),
                      trailing: Text(
                        state.cardInfo.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      title: Text(S.current.phoneNoTitle),
                      subtitle: TextField(
                        maxLines: 1,
                        autofocus: !state.isBind,
                        controller: state.phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: S.current.enterPhoneNo,
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          // border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(S.current.remark),
                      subtitle: TextField(
                        maxLines: 1,
                        controller: state.remarkController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: S.current.enterRemark,
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          // border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (state.isBind)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          S.current.alreadyBind,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                          onPressed: !state.isBind
                              ? () => dispatch(
                                  EditMemberActionCreator.onSubmitClick())
                              : null,
                          child: Center(child: Text(S.current.add))),
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
    ),
  );
}
