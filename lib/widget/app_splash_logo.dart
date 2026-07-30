import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

/// Splash / ScanLogin cover: white + logo at a fixed size.
///
/// Size matches Android 12 system splash icon (~240dp) and native
/// `launch_background`, so cold-start does not jump large → small.
class AppSplashLogo extends StatelessWidget {
  const AppSplashLogo({
    super.key,
    this.useHero = true,
  });

  static const heroTag = 'app_splash_logo';

  /// Same as Android `launch_background` logo item.
  /// Slightly under the system splash icon frame (240dp) so the 2nd frame
  /// does not look bigger than the 1st.
  static const double logoSize = 200;

  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final logoFolder =
        AppConfig.of(context).appInternalId == AppType.googleLite ? '2' : '1';

    Widget image = Image.asset(
      'assets/images/$logoFolder/app_logo.png',
      fit: BoxFit.contain,
      width: logoSize,
      height: logoSize,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/$logoFolder/app_logo_fg.png',
        fit: BoxFit.contain,
        width: logoSize,
        height: logoSize,
      ),
    );
    if (useHero) {
      image = Hero(tag: heroTag, child: image);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: Colors.white,
        child: Center(child: image),
      ),
    );
  }
}
