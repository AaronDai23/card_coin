import 'dart:io';

import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../generated/l10n.dart';
import '../../widgets/custom_widget_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CropImageState state, Dispatch dispatch, ViewService viewService) {
  final Size size = MediaQuery.of(viewService.context).size;
  return Scaffold(
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
    ),
    body: Container(
      height: size.height,
      width: size.width,
      color: const Color(0xFF121212),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.7,
            width: size.width * 0.9,
            child: Crop(
              image: state.imageBytes,
              controller: state.cropController,
              aspectRatio: state.aspectRatio,
              onCropped: (CropResult result) async {
                if (result is! CropSuccess) {
                  showToast(S.current.cutPhoneFailure);
                  return;
                }
                try {
                  final dir = await getTemporaryDirectory();
                  final out = File(
                    '${dir.path}/avatar_crop_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  );
                  await out.writeAsBytes(result.croppedImage, flush: true);
                  state.lastCropped = out;
                  if (viewService.context.mounted) {
                    Navigator.pop(viewService.context, out.path);
                  }
                } catch (_) {
                  showToast(S.current.cutPhoneFailure);
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: ZenggeButton(
              child: Text(S.current.comfirm),
              onPressed: () => dispatch(CropImageActionCreator.onCrop()),
            ),
          )
        ],
      ),
    ),
  );
}
