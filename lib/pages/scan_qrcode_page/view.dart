import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ScanQrcodeState state, Dispatch dispatch, ViewService viewService) {
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
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.of(viewService.context).pop();
        },
      ),
      title: Text(languageResource.scanQrCode),
    ),
    body: Stack(
      children: [
        ScanView(
          controller: state.controller,
          scanAreaScale: 0.7,
          scanLineColor: const Color(0xff0575aa),
          onCapture: (data) => Navigator.pop(viewService.context, data),
        ),
        Positioned(
          left: 80,
          bottom: 80,
          child: MaterialButton(
            child:
                Icon(state.lightIcon, size: 50, color: const Color(0xff0575aa)),
            onPressed: () {
              dispatch(ScanQrcodeActionCreator.onToggleTorchMode());
              dispatch(ScanQrcodeActionCreator.onTurnFlash());
            },
          ),
        ),
        Positioned(
          right: 80,
          bottom: 80,
          child: MaterialButton(
            child: const Icon(Icons.image, size: 50, color: Color(0xff0575aa)),
            onPressed: () {
              dispatch(ScanQrcodeActionCreator.onPickImage());
            },
          ),
        )
      ],
    ),
  );
}
