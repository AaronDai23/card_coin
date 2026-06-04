
import 'package:card_coin/card_base/extensions/ext_string.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_service/keyboard_service.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../widget/base_page_loading.dart';
import '../../../../widgets/password_input_text.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    AddCardState state, Dispatch dispatch, ViewService viewService) {
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
        title: Text(S.current.addCard),
      ),
      body: BasePageLoadingView(
        errorMsg: state.errorMsg,
        loadStatus: state.loadStatus,
        onReload: (){
          dispatch(AddCardActionCreator.onShowLoading());
          dispatch(AddCardActionCreator.onLoadData());
        },
        buildBody: (isLoadSuccess) {
          if (isLoadSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      S.current.cardNo,
                    ),
                    trailing: Text(
                      (state.cardInfo.cardNum ?? '')
                          .stringSeprate(count: 4, separator: ' '),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      S.current.cardBrand,
                    ),
                    trailing: Text(
                      state.cardInfo.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      S.current.currentAmount,
                    ),
                    trailing: Text(
                      '${state.cardInfo.amount}',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  ListTile(
                    title: Text(S.current.cardName),
                    subtitle: TextField(
                      maxLines: 1,
                      autofocus: !state.isBindCard,
                      controller: state.nameController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: S.current.enterCardName,
                        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                        // border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ListTile(
                    title: Text(S.current.password),
                    subtitle: Column(
                      children: [
                        PasswordInputText(
                            placeholder: S.current.enterPwd,
                            obscureText: true,
                            textController:  state.passwordController),
                        const Divider(color: Colors.black,)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (state.isBindCard)
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
                        onPressed: !state.isBindCard
                            ? () => dispatch(AddCardActionCreator.onSubmitClick())
                            : null,
                        child: Center(child: Text(S.current.add))),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    ),
  );
}
