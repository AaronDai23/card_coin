import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../../../custom_widget/load_image.dart';
import '../adapter/state.dart';

Widget buildView(
    CardGroupItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () => Navigator.of(viewService.context)
        .pushNamed('groupCardDetailPage', arguments: {'cardGroup': state.bean}),
    child: Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xFF159bfc).withOpacity(0.3),
            offset: const Offset(0, 0),
            blurRadius: 5.0)
      ], borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LoadImage(
              state.bean.background ?? "",
              fit: BoxFit.fill,
              holderImg: const LoadAssetImage(
                '1/card_bg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: LoadImage(
                state.bean.groupImage!,
                width: 50,
                height: 50,
              )),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                state.bean.groupName != null
                    ? "${state.bean.groupName}(${state.bean.cardCount})"
                    : "",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 1.0,
                        color: Color.fromARGB(180, 0, 0, 0),
                      ),
                    ]),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
