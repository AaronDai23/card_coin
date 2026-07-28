import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../widget/app_splash_logo.dart';
import 'state.dart';

Widget buildView(
    SplashState state, Dispatch dispatch, ViewService viewService) {
  return const AppSplashLogo();
}
