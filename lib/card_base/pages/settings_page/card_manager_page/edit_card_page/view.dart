import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    EditCardState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(S.current.editCardInfo),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ListTile(
            title: Text(S.current.cardName, style: const TextStyle(fontSize: 14.0)),
            subtitle: TextField(
              maxLines: 1,
              autofocus: true,
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
          Row(
            children: [
              if (!(state.cardInfo.major ?? false))
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ElevatedButton(
                      onPressed: () =>
                          dispatch(EditCardActionCreator.onSetMainClick()),
                      child: Text(S.current.setMainCard)),
                )),
              Expanded(
                  child: ElevatedButton(
                onPressed: () =>
                    dispatch(EditCardActionCreator.onUpdateNameClick()),
                child: Text(S.current.comfirm),
              ))
            ],
          )
        ],
      ),
    ),
  );
}
