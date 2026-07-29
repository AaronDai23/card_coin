import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

/// Shared splash / ScanLogin cover. Always full-bleed white (ignore system dark).
class AppSplashLogo extends StatelessWidget {
  const AppSplashLogo({
    super.key,
    this.useHero = true,
  });

  /// Keep in sync with Android `launch_background` splash icon (240dp).
  static double logoSideOf(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return (shortest * 0.62).clamp(200.0, 240.0);
  }

  static const heroTag = 'app_splash_logo';

  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final logoFolder =
        AppConfig.of(context).appInternalId == AppType.googleLite ? '2' : '1';
    final side = logoSideOf(context);

    Widget logo = Image.asset(
      'assets/images/$logoFolder/app_logo_fg.png',
      fit: BoxFit.contain,
      width: side,
      height: side,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/$logoFolder/app_logo.png',
        fit: BoxFit.contain,
        width: side,
        height: side,
      ),
    );
    if (useHero) {
      logo = Hero(
        tag: heroTag,
        child: logo,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.white,
          child: Center(child: logo),
        ),
      ),
    );
  }
}
