import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

/// Shared splash / ScanLogin cover. Always full-bleed; logo size from screen only.
class AppSplashLogo extends StatelessWidget {
  const AppSplashLogo({super.key});

  /// Keep in sync with Android `launch_background` splash icon (240dp).
  static double logoSideOf(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return (shortest * 0.62).clamp(200.0, 240.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bg = isDark ? Colors.black : Colors.white;
    final logoFolder =
        AppConfig.of(context).appInternalId == AppType.googleLite ? '2' : '1';
    final side = logoSideOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      // Force full viewport — avoids Stack/Scaffold sizing the logo box smaller.
      child: SizedBox.expand(
        child: ColoredBox(
          color: bg,
          child: Center(
            child: Image.asset(
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
            ),
          ),
        ),
      ),
    );
  }
}
