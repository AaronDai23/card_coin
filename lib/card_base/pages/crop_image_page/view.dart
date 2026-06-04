import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import '../../../generated/l10n.dart';
import '../../widgets/custom_widget_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    CropImageState state, Dispatch dispatch, ViewService viewService) {
  Size size = MediaQuery.of(viewService.context).size;
  print('screen width:${size.width}');
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
      // title: Text('绑定手机号'),
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
            child: Crop.file(
              state.file,
              key: state.cropKey,
              aspectRatio: state.aspectRatio,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: ZenggeButton(
              child: Text(S.current.comfirm),
              onPressed: () => dispatch(
                CropImageActionCreator.onCrop(),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
