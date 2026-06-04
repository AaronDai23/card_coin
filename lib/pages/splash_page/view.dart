import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';
import '../../widget/app_config.dart';
import 'state.dart';

Widget buildView(
    SplashState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    color: Colors.white,
    child: Center(
      child: LoadAssetImage(
        '${AppConfig.of(viewService.context).appInternalId == AppType.googleLite ? '2' : '1'}/app_logo',
        fit: BoxFit.contain,
        width: 200,
        height: 300,
      ),
    ),
  );
}
