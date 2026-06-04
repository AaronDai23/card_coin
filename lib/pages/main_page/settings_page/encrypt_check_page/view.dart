import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    EncryptCheckState state, Dispatch dispatch, ViewService viewService) {
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
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('加密内容：'),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6)),
            child: TextField(
                maxLines: 4,
                controller: state.controller,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    border: OutlineInputBorder(borderSide: BorderSide.none))),
          ),
          const SizedBox(
            height: 20,
          ),
          CCButton(
            child: const Text('加密'),
            onPressed: () => dispatch(EncryptCheckActionCreator.onBtnClick()),
          ),
          const SizedBox(
            height: 20,
          ),
          if (state.appData.isNotEmpty)
            Text('手机加密：${state.appData}\n\n卡片加密：${state.cardData}')
        ],
      ),
    ),
  );
}
